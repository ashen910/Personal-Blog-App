//
//  MainView.swift
//  Personal Blog App
//
//  Created by Ashen Wijenayake on 2023-06-16.
//

import SwiftUI

struct MainView: View {
    var body: some View {
     //Note: Tabview with recent post's and profiles tabs
        TabView{
            PostsView()
            .tabItem{
                    Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled")
                    Text("Post's")
                }
           ProfileView()
                .tabItem{
                    Image(systemName: "gear")
                    Text("Profile")
                }
        }
        //Changing Tab Label tint to Black
        .tint(.black)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
