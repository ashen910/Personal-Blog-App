# Project Name - Personal Blog App
# Student Id - IT20133122
# Student Name - Wijenayake R.A.E

#### 01. Brief Description of Project - 
This is a social media app was done with the use of XCode14,SwiftUI and Firebase.It has validations,crud operations. personal blog app built to do simples things like publishing quotes and photos.

#### 02. Users of the System - 
System Users only

#### 03. What is unique about your solution -
Social media apps are popular because they allow people to connect and communicate with each other in a fast,easy and convenient way.They offer a platform for people tho share their thoughts,ideas and experience.In here we only giving accessing to posting text and photos only because most of the social media app has so many functionalities and sometimes its expose the users privacy to the world.

#### 04. Differences of Assignment 02 compared to Assignment 01


#### 05. Briefly document the functionality of the screens you have (Include screen shots of images)
![Screen1] - The first screen is showing the registeration form for the system,login button, and sign up. 
![Screen2] - This screen is showing the filled register form with the user profile image.
![Screen3] - This screeen is used to login for existing user to the system. Its also appear the register now button.
![Screen4] - This screen is used to show the homepage of the system. Its appear the Users contents. 
![Screen5] - This screen is used to show the user profile.
![Screen6] - The sixth screen shows the logout button and delete account buttons top right corner of the page.
![Screen7] - Also in this page we can see the delete post function and user's posts.
![Screen8] - This screen shows the edit ,delete image and posting functions.

#### 06. Give examples of best practices used when writing code

Variable naming conventions,Class and function naming conventions,comments,Reusability and scalability


 ... struct ReusableProfileContent: View {
    var user: User
    @State private var fetchedPosts: [Post] = []
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack{
                HStack(spacing: 12){
                    WebImage(url: user.userProfileURL).placeholder{
                        //Note: Placeholder image
                        Image("NullProfile")
                            .resizable()
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 6) {
                        Text(user.username)
                            .font(.title3)
                            .fontWeight(.semibold)

                        Text(user.userBio)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .lineLimit(3)

                    }
                    .hAlign(.leading)
                } ...//

#### 07. UI Components used

The following components were used in the Personal Blog App, 
    UIButton, 
    UIAlert,
    UIText views,
    Image views,
    Labels,
    lockups,
    Search fields,
    scroll views,
    Image wells

#### 08. Testing carried out

#### 09. Documentation 

(a) Design Choices
Data Structures
Code Organization to navigate easily
Error handling
Code Style

(b) Implementation Decisions
Software design pattern to write code that is easy to maintain, extend, and reuse.
Coding standards and best practices to maintain the code quality.
Error handling and debugging for software to make the software more reliable.

(c) Challenges
Bugs and errors can be frustrating and time-consuming to identify and fix.
When using a new programming languages, frameworks, and tools can have a little difficult to coding when implementing the functions.
Projects often have strict deadlines, which can add pressure to the coding process.

#### 10. Additional iOS library used


#### 11. Reflection of using SwiftUI compared to UIKit
SwiftUI is perfect for rapidly developing apps with simple to medium-complexity interfaces.Its excellent for prototyping and creating small uis for the ios app.Using UIKIt can create more complex ios interfaces and complex functionality. 

#### 12. Reflection General

Time management issues- because of the job and other assignment and research.

  

