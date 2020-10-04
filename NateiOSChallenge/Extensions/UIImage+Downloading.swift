//
//  UIImage+Downloading.swift
//  nate.ios.challenge.
//
//  Created by Francesca Palese on 29/09/2020.
//
import UIKit

extension UIImageView {
    
    private struct ImageCache {
        static let image = NSCache<NSString, UIImage>()
    }
    
    func loadImage(urlString: String, completion: @escaping (Bool) -> Void) -> URLSessionDownloadTask? {  
        let session = URLSession.shared
        
        guard let url = URL(string: urlString) else {
            completion(false)
            return nil
        }
        
        if let imageFromCache = ImageCache.image.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return nil
        }
        
        let downloadTask = session.downloadTask(with: url, completionHandler: { [weak self] url, response, error in
            
            if error == nil, let url = url,
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                
                DispatchQueue.main.async {
                    if let weakSelf = self {
                        let imageToCache = image
                        
                        ImageCache.image.setObject(imageToCache, forKey: urlString as NSString)
                        
                        weakSelf.image = imageToCache
                        
                        completion(true)
                    }
                }
                
            } else {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        })
        
        downloadTask.resume()
        return downloadTask
    }
    
    func loadImageUsingCacheWithUrlString(urlString:String) {
        
        self.image = nil
        
        //Check cache for image first
        if let cacheImage = ImageCache.image.object(forKey: urlString as NSString)  {

            self.image = cacheImage
            return
        }
        
        //Otherwise fire off a new download
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            if error == nil {
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data:data!){
                    ImageCache.image.setObject(downloadedImage, forKey: urlString as NSString)
                    self.image = downloadedImage
                }
            }
            } else {
//                TODO: handle the error
                print(error)
                return
            }
        }).resume()
    }
    
}
