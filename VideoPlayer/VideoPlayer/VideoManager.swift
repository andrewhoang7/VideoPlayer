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

class VideoManager: ObservableObject {
    @Published private(set) var videos: [Video] = []
    @Published var selectedQuery: Query = Query.nature {
        didSet {
            Task.init {
                await findVideos(topic: selectedQuery)
            }
        }
    }
    
    init() {
        Task.init {
            await findVideos(topic: selectedQuery)
        }
    }
    
    func findVideos(topic: Query) async {
        do {
            guard let url = URL(string: "https://api.pexels.com/v1/search?query=\(topic)&per_page=10&orientation=portrait") else { fatalError("Missing URL") }
            var urlRequest = URLRequest(url: url)
            urlRequest.setValue("563492ad6f917000010000012d241364a88b44c6a55359057a96d07a", forHTTPHeaderField: "Authorization")
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data")}
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try decoder.decode(ResponseBody.self, from: data)
            
            self.videos = []
            self.videos = decodedData.videos
            
        } catch {
            print("Error fetching data from Pexels: \(error)")
        }
    }
}

struct ResponseBody: Decodable {
    let page: Int
    let perPage: Int
    let totalResults: Int
    let url: String
    let videos: [Video]
}

struct Video: Decodable, Identifiable {
    let id: Int
    let image: String
    let duration: Int
    let user: User
    let videoFiles: [VideoFile]
    
    struct User: Decodable, Identifiable {
        let id: Int
        let name: String
        let url: String
    }
    
    struct VideoFile: Decodable {
        let id: Int
        let quality: String
        let fileType: String
        let link: String
    }
}

