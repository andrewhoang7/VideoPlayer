//
//  VideoManager.swift
//  VideoPlayer
//
//  Created by Andrew Hoang on 2/6/22.
//

import Foundation

//CaseIterable allows the ability to iterate over all the cases in our view
enum Query: String, CaseIterable {
   case nature, animals, people, ocean, food
}


struct ResponseBody: Decodable {
    let page: Int
    let per_page: Int
    let total_results: Int
    let url: String
    let videos: [Video]
    
    struct Video: Decodable, Identifiable {
        let id: Int
        let image: String
        let duration: Int
        let user: User
        let video_files: [VideoFile]
        
        struct User: Decodable, Identifiable {
            let id: Int
            let name: String
            let url: String
        }
        
        struct VideoFile: Decodable {
            let id: Int
            let quality: String
            let file_type: String
            let link: String
        }
    }
}

