//
//  RegisterView.swift
//  Personal Blog App
//
//  Created by Ashen Wijenayake on 2023-06-15.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PhotosUI

//MARk:Register View
struct RegisterView: View{
    //MARK : User Details
    @State var emailID: String = ""
    @State var password: String = ""
    @State var userName: String = ""
    @State var userBio: String = ""
    @State var userProfilePicData: Data?
    
    //Mark: View Properties
    @Environment(\.dismiss) var dismiss
    @State var showImagePicker: Bool = false
    @State var photoItem: PhotosPickerItem?
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    
    //Mark: User Defaults
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    var body: some View{
        VStack(spacing:10){
            Text("Lets Register\nAccount")
                .font(.largeTitle.bold())
                .hAlign(.leading)
            
            Text("Hello User, have a wonderful journey")
                .font(.title3)
                .hAlign(.leading)
            
            //MARK: For Smaller Size Optimization
            //This will automatically enable scrollview if the content exceeds more than the available space
            ViewThatFits{
                ScrollView(.vertical, showsIndicators: false){
                    HelperView()
                }
                HelperView()
            }
            
            //MArk:Register Button
            HStack{
                Text("Already Have an Account?")
                    .foregroundColor(.gray)
                Button("Login Now"){
                    dismiss()
                }
                .fontWeight(.bold)
                .foregroundColor(.black)
            }
            .font(.callout)
            .vAlign(.bottom)
        }
        .vAlign(.top)
        .padding(15)
        .overlay(content:{
            LoadingView(show: $isLoading)
        })
        .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
        .onChange(of: photoItem){newValue in
            //Mark: Extracting UIIMage From PhotoItem
            if let newValue{
                Task{
                    do{
                        guard let imageData = try await newValue.loadTransferable(type: Data.self)else {return}
                        //MARk: UI Must Be Update on main thread
                        await MainActor.run(body: {userProfilePicData = imageData
                            
                        })
                        
                    }catch{
                        
                    }
                }
            }
            
        }
        //Mark: Displaying Alert
        .alert(errorMessage, isPresented: $showError, actions: {})
    }
    
    @ViewBuilder
    func HelperView()->some View{
        VStack(spacing: 12){
            ZStack{
                if let userProfilePicData,let image = UIImage(data: userProfilePicData){
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }else{
                    Image("NullProfile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
            .frame(width: 85, height: 85)
            .clipShape(Circle())
            .contentShape(Circle())
            .padding(.top,25)
            .onTapGesture {
                showImagePicker.toggle()
            }
            
            TextField("Username", text: $userName)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
            
            TextField("Email", text: $emailID)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
            
            SecureField("Password", text: $password)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
            
            TextField("About You", text: $userBio,axis: .vertical)
                .frame(minHeight: 100,alignment: .top)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
            
            Button(action: registerUser){
                //MARk: Register Button
                Text("Sign In")
                    .foregroundColor(.white)
                    .hAlign(.center)
                    .fillView(.blue.opacity(0.7))
            }
            .disableWithOpacity(userName == "" || userBio == "" || emailID == "" || password == "" || userProfilePicData == nil )
            .padding(.top,10)
        }
    }
    func registerUser(){
        isLoading = true
        closeKeyboard()
        Task{
            do{
                
                //Step 1: Creatimng Firebase Account
               try await Auth.auth().createUser(withEmail: emailID, password: password)
                
                //Step 2: Uploading profile Photo into Firebase Storage
                guard let userUID = Auth.auth().currentUser?.uid else{return}
                guard let imageData = userProfilePicData else{return}
                let storageRef = Storage.storage().reference().child("Profile_Image").child(userUID)
                let _ = try await storageRef.putDataAsync(imageData)
                
                //Step 3: Downloading Photo URL
                let downloadURL = try await storageRef.downloadURL()
                
                //Step 4: Creating a user firestore Object
                let user = User(username: userName, userBio: userBio, userUID: userUID, userEmail: emailID, userProfileURL: downloadURL)
                
                //Step 5: Saving user doc to the Firestore Database
                let _ = try Firestore.firestore().collection("Users").document(userUID).setData(from: user, completion:{
                    error in
                    if error == nil{
                        //MARK: print Saved Succesfully
                        print("Saved Successfully")
                        userNameStored = userName
                        self.userUID = userUID
                        profileURL = downloadURL
                        logStatus = true
                    }
                })
                
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


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
