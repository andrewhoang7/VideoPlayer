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
            guard let url = URL(string: "https://api.pexels.com/videos/search?query=\(topic)&per_page=10&orientation=portrait") else { fatalError("Missing URL") }
            var urlRequest = URLRequest(url: url)
            urlRequest.setValue("563492ad6f917000010000012d241364a88b44c6a55359057a96d07a", forHTTPHeaderField: "Authorization")
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data")}
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try decoder.decode(ResponseBody.self, from: data)
            
            DispatchQueue.main.async {
                self.videos = []
                self.videos = decodedData.videos
            }
            
        } catch {
            print("Error fetching data from Pexels: \(error)")
        }
    }
}

struct ResponseBody: Decodable {
    var page: Int
    var perPage: Int
    var totalResults: Int
    var url: String
    var videos: [Video]
}

struct Video: Decodable, Identifiable {
    var id: Int
    var image: String
    var duration: Int
    var user: User
    var videoFiles: [VideoFile]
    
    struct User: Decodable, Identifiable {
        var id: Int
        var name: String
        var url: String
    }
    
    struct VideoFile: Decodable {
        var id: Int
        var quality: String
        var fileType: String
        var link: String
    }
}

