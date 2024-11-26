//
//  ProfileView.swift
//  Personal Blog App
//
//  Created by Ashen Wijenayake on 2023-06-16.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct ProfileView: View {
    //Note: My profile data
    @State private var myProfile: User?
    @AppStorage("log_status") var logStatus: Bool = false
    
    //Note: View properties
    @State var errorMessage: String = ""
    @State var showError: Bool = false
    @State var isLoading: Bool = false
    var body: some View {
        NavigationStack{
            VStack{
                if let myProfile{
                    ReusableProfileContent(user: myProfile)
                        .refreshable {
                            //Mark: Refresh user data
                            self.myProfile = nil
                            await fetchUserData()
                            
                        }
                }else{
                    ProgressView()
                }
            }
            .navigationTitle("My Profile")
            .toolbar {
                ToolbarItem(placement: . navigationBarTrailing){
                    Menu {
                        //Note: Two actions
                        //1. Logout
                        //2.Delete account
                        Button("Logout",action: logOutUser)
                        Button("Delete Account",role: .destructive,action: deleteAccount)
                    } label:{
                        Image(systemName: "ellipsis")
                            .rotationEffect(.init(degrees:  90))
                            .tint(.black)
                            .scaleEffect(0.8)
                    }
                }
            }
            
        }
            .overlay {
                LoadingView(show: $isLoading)
            }
            .alert(errorMessage, isPresented: $showError){
            }
            .task {
                //this modifier is like on Appear
                //So fetching for the first time only
                if myProfile != nil{return}
                //Mark: initial fetch
                await fetchUserData()
            }
    }
    //Note: Fetching User Data
    func fetchUserData()async{
        guard let userUId = Auth.auth().currentUser?.uid else{return}
        guard let user = try? await Firestore.firestore().collection("Users").document(userUId).getDocument(as: User.self)
        else{return}
        await MainActor.run(body: {
            myProfile = user
        })
    }
    
    // Note: Login user Out
    func logOutUser(){
        try? Auth.auth().signOut()
        logStatus = false
        }
    //Note: Deleting User Entire Account
    func deleteAccount(){
        isLoading = true
        Task{
            do{
                guard let userUID = Auth.auth().currentUser?.uid else{return}
                
                // Step1 : Delete Image from profile storage
                let reference = Storage.storage().reference().child("Profile_Images").child(userUID)
                try await reference.delete()
                
                // Step 2: Deletingfirestore user document
                try await Firestore.firestore().collection("Users").document(userUID).delete()
                
                // Final Step: Deleting Auth Account and Setting Log Status to false
                try await Auth.auth().currentUser?.delete()
                logStatus = false
                
            }catch{
                await setError(error)
            }
            
        }
    }
    //Note: Setting Error
    func setError(_ error: Error)async{
        //Note UI must be run on main thread
        await MainActor.run(body: {
            isLoading = false
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
