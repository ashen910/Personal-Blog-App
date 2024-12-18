//
//  Post.swift
//  Personal Blog App
//
//  Created by Ashen Wijenayake on 2023-06-16.
//

import SwiftUI
import FirebaseFirestoreSwift
import FirebaseStorage

//MARk: Post Model
struct Post: Identifiable,Codable {
    @DocumentID var id: String?
    var text: String
    var imageURL: URL?
    var imageReferenceID: String = ""
    var publishedDate: Date = Date()
    var likedIDs: [String] = []
    var dislikedIDs: [String] = []
    
    //Mark: BAsic USer Info
    var userName: String
    var userUID: String
    var userProfileURL: URL
    
    enum CodingKeys : CodingKey {

        case id
        case text
        case imageURL
        case imageReferenceID
        case publishedDate
        case likedIDs
        case dislikedIDs
        case userName
        case userUID
        case userProfileURL
    }
}
