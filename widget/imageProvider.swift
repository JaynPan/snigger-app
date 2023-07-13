//
//  imageProvider.swift
//  meme
//
//  Created by 潘傑恩 on 2023/7/10.
//

import Foundation
import SwiftUI

enum ImageResponse {
    case Success(image: UIImage, id: String)
    case Failure
}

struct ApiResponse: Decodable {
    var url: String
    var id: String
}

class ImageProvider {
    static func getImageFromApi(completion: ((ImageResponse) -> Void)?) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let urlString = "https://us-central1-giggle-ff996.cloudfunctions.net/app/api/randomMeme"
        
        let url = URL(string: urlString)!
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            parseResponseAndGetImage(data: data, urlResponse: urlResponse, error: error, completion: completion)
        }
        task.resume()
    }
    
    static func parseResponseAndGetImage(data: Data?, urlResponse: URLResponse?, error: Error?, completion: ((ImageResponse) -> Void)?) {
        
        guard error == nil, let content = data else {
            print("error getting data from API")
            let response = ImageResponse.Failure
            completion?(response)
            return
        }
        
        var apiResponse: ApiResponse
        do {
            apiResponse = try JSONDecoder().decode(ApiResponse.self, from: content)
        } catch {
            print("error parsing URL from data")
            let response = ImageResponse.Failure
            completion?(response)
            return
        }
        
        let url = URL(string: apiResponse.url)!
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            parseImageFromResponse(data: data, urlResponse: urlResponse, error: error, apiResponse: apiResponse, completion: completion)
        }
        task.resume()
        
    }
    
    static func parseImageFromResponse(data: Data?, urlResponse: URLResponse?, error: Error?, apiResponse: ApiResponse, completion: ((ImageResponse) -> Void)?) {
        
        guard error == nil, let content = data else {
            print("error getting image data")
            let response = ImageResponse.Failure
            completion?(response)
            return
        }
        
        let image = UIImage(data: content)!
        let response = ImageResponse.Success(image: image, id: apiResponse.id)
        completion?(response)
    }
}
