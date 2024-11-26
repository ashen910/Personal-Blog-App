//
//  Personal_Blog_AppApp.swift
//  Personal Blog App
//
//  Created by Ashen Wijenayake on 2023-06-16.
//

import SwiftUI
import Firebase

@main
struct Personal_Blog_AppApp: App {
    init (){
        //Initializing firebase
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
