//
//  ContentView.swift
//  Personal Blog App
//
//  Created by Ashen Wijenayake on 2023-06-16.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("log_status") var logStatus: Bool = false
    var body: some View {
      //Mark: Redirecting user  based on log status
      if logStatus{
            MainView()
       }else{
           LoginView()
           
       }
      
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
