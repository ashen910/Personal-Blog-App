//
//  User.swift
//  Personal Blog App
//
//  Created by Ashen Wijenayake on 2023-06-16.
//

import SwiftUI
import FirebaseFirestoreSwift

struct User: Identifiable,Codable{
    @DocumentID var id: String?
    var username: String
    var userBio: String
    var userUID: String
    var userEmail: String
    var userProfileURL: URL
    
    enum CodingKeys: CodingKey {
        case id
        case username
        case userBio
        case userUID
        case userEmail
        case userProfileURL
    }
    
   
}
