//
//  NetworkManager.swift
//  CineMate
//
//  Created by Ritika Gupta on 01/11/24.
//

import UIKit

final class NetworkManager {
    static let shared = NetworkManager()
    let imageCache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        if let image = imageCache.object(forKey: cacheKey) {
            completion(image)
            return
        }
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            self.imageCache.setObject(image, forKey: NSString(string: urlString))
            
            completion(image)
        }
        
        task.resume()
    }
}
