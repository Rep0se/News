//
//  ApiService.swift
//  News
//
//  Created by Alexander Sundiev on 2019-12-20.
//  Copyright © 2019 Alexander Sundiev. All rights reserved.
//

import Foundation

class ApiService {
    // MARK: Singleton Implementation
    private init() {}
    static let shared = ApiService()
    
    // MARK: - Convenience Objects
    enum HttpMethod: String {
        case get = "GET"
    }
    
    struct Constants {
        static let baseUrl: String = "https://newsapi.org/v2/top-headlines"
        static let country: String = "ca"   // in future can be set in UserDefaults and be dynamic based on current location or chosen setting
        static let apiKey: String = "d5ee1b7f9737494fb050c33e3a15668c" // in future can be set in UserDefaults
        static let requestUrl: String = "\(baseUrl)?country=\(country)&apiKey=\(apiKey)"
    }
    
    private func request(url: URL, httpMethod: HttpMethod) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        return request
    }
    
    // MARK: - API Methods
    func readAll(completion: @escaping (TopNews) -> Void) {
        let requestUrl = Constants.requestUrl
        guard let url = URL(string: requestUrl) else {
            print("Error: Cannot create URL")
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request(url: url, httpMethod: .get)) { (data, response, error) in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(TopNews.self, from: data)
                print(result)
                completion(result)
            } catch let jsonErr {
                print("Error serializing JSON: \(jsonErr)")
            }
        }
        task.resume()
    }
    
    func readPage(page: Int, completion: @escaping (TopNews) -> Void){
        let requestUrl = "\(Constants.baseUrl)?country=\(Constants.country)&page=\(page)&apiKey=\(Constants.apiKey)"
        guard let url = URL(string: requestUrl) else {
            print("Error: Cannot create URL")
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request(url: url, httpMethod: .get)) { (data, response, error) in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(TopNews.self, from: data)
                print("Result: \(result)")
                print("Response: \(String(describing: response))")
                completion(result)
            } catch let jsonErr {
                print("Error serializing JSON: \(jsonErr)")
            }
        }
        task.resume()
    }
}
