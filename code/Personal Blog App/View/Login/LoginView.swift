//
//  LoginView.swift
//  Personal Blog App
//
//  Created by Ashen Wijenayake on 2023-06-15.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct LoginView: View {
    //MARK : User Details
    @State var emailID: String = ""
    @State var password: String = ""
    
    //MARK: View Properties
    @State var createAccount: Bool = false
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    
    //Mark: User defaults
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    
    var body: some View {
        VStack(spacing:10){
            Text("Lets Sign you in")
                .font(.largeTitle.bold())
                .hAlign(.leading)
            
            Text("Welcome Back,\nYou have been missed")
                .font(.title3)
                .hAlign(.leading)
            
            VStack(spacing: 12){
                TextField("Email", text: $emailID)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                    .padding(.top,25)
                
                SecureField("Password", text: $password)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                    .padding(.top,25)
                
                Button("Reset Password?", action: resetPassword)
                    .font(.callout)
                    .fontWeight(.medium)
                    .tint(.black)
                    .hAlign(.trailing)
                
                Button(action: loginUser){
                    //MARk: Login Button
                    Text("Sign In")
                        .foregroundColor(.white)
                        .hAlign(.center)
                        .fillView(.blue.opacity(0.7))
                }
            }
            
            //MArk:Register Button
            HStack{
                Text("Don't have an Account?")
                    .foregroundColor(.gray)
                Button("Register Now"){
                    createAccount.toggle()
                }
                .fontWeight(.bold)
                .foregroundColor(.black)
            }
            .font(.callout)
            .vAlign(.bottom)
        }
        .vAlign(.top)
        .padding(15)
        .overlay(content: {
            LoadingView(show: $isLoading)
        })
        
        //MARK: Register View VIA Sheets
        .fullScreenCover(isPresented: $createAccount){
            RegisterView()
        }
        //MArk: Displaying Alert
        .alert(errorMessage, isPresented: $showError, actions: {})
    }
    func loginUser(){
        isLoading = true
        closeKeyboard()
        Task{
            do{
                //with help of swift concurrency Auth can be done with Singel Line
                try await Auth.auth().signIn(withEmail: emailID, password: password)
                print("User Found")
                try await fetchUser()
            }catch{
                await setError(error)
            }
        }
    }
    //Mark: If user if found then fetching user data from firestore
    func fetchUser()async throws{
        guard let userID = Auth.auth().currentUser?.uid else{return}
        let user = try await Firestore.firestore().collection("Users").document(userID).getDocument(as: User.self)
        //Mark:  UI updating must be run on main thread
        await MainActor.run(body: {
            //setting userdefaulkt data and Changing app's Auth Status
            userUID = userID
            userNameStored = user.username
            profileURL = user.userProfileURL
            logStatus = true
        })
    }
    func resetPassword(){
        Task{
            do{
                //with help of swift concurrency Auth can be done with Singel Line
                try await Auth.auth().sendPasswordReset(withEmail: emailID)
                print("Link Sent!")
            }catch{
                await setError(error)
            }
        }
    }
    
   //Mark: Displaying Errors VIA Alert
    func setError(_ error: Error)async{
        //Mark: Ui must be updated on thread
        await MainActor.run(body:{
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


