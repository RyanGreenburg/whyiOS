//
//  PostController.swift
//  whyiOS
//
//  Created by RYAN GREENBURG on 2/6/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import Foundation

class PostController {
    //Source of truth
    var posts: [Post] = []
    // Shared instance
    static let shared = PostController()
    // Base URL
    let baseURL = URL(string: "https://whydidyouchooseios.firebaseio.com/reasons")
    
    func fetchPosts(completion: @escaping ((Bool) -> Void)) {
        // Unwrap baseURL
        guard let unwrappedURL = baseURL else { completion(false); return }
        // full url
        let getterEndpoint = unwrappedURL.appendingPathComponent(".json")
        // Create request & type
        var urlRequest = URLRequest(url: getterEndpoint)
        urlRequest.httpMethod = "GET"
        // Data Task
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            // Handle the error
            if let downloadError = error {
                print("Error fetching posts. \(downloadError.localizedDescription)")
                completion(false)
            }
            // Check for data
            guard let data = data else { completion(false); return }
            // Use the data
            do {
                let decoder = JSONDecoder()
                let postsDictionary = try decoder.decode([String:Post].self, from: data)
                let postsArray = postsDictionary.compactMap({ $0.value })
                // Is shared instance better or self.posts = postsArray? does shared instance mean we do not need to mark the funcions as static?
                self.posts = postsArray
                completion(true)
            } catch {
                print("Error decoding posts \(error)")
                completion(false)
            }
        }
        dataTask.resume()
    }
    
    func postReason(cohort: String, name: String, reason: String, completion: @escaping ((Bool) -> Void)) {
        // Unwrap baseURL
        guard let unwrappedURL = baseURL else { completion(false); return }
        // Create full url
        let postEndpoint = unwrappedURL.appendingPathComponent(".json")
        // Create object
        let post = Post.init(cohort: cohort, name: name, reason: reason)
        // Cast object as Data
        var postData = Data()
        // Create request
        var urlRequest = URLRequest(url: postEndpoint)
        urlRequest.httpMethod = "POST"
        // Encode object as Data
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(post)
            postData = data
        } catch {
            print("Error encoding new post \(error.localizedDescription)")
            completion(false)
        }
        urlRequest.httpBody = postData
        // Data Task
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            // Handle the error
            if let uploadError = error {
                print("Error uploading new post \(uploadError.localizedDescription)")
                completion(false)
            }
            // Unwrap the data
            guard data != nil else {
                print("No data was received.")
                completion(false)
                return
            }
            // Append post and complete
            self.posts.append(post)
            completion(true)
        }
        dataTask.resume()
    }
}// End of class
