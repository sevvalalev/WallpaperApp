//
//  ImageManager.swift
//  WallpaperApp
//
//  Created by Sevval Alev on 9.01.2023.
//

import Foundation
import Alamofire

enum BaseURLS {
    case base
    case random
    case query(searchedText: String)
    
    func getURL() -> String {
        switch self {
        case .base:
            return C.URL.baseUrl
        case .random:
            return C.URL.randomUrl
        case .query(let searchedText):
            return C.URL.baseUrl + "&query=\(searchedText))"
        }
    }
}

protocol SendPictureDataTransferDelegate: AnyObject {
    func sendPictureData(picture: ImageData)
}

class ImageManager {
    
    weak var delegate:SendPictureDataTransferDelegate?
    
    func fetchPhotos(type: BaseURLS) {
        
        guard let url = URL(string: type.getURL()) else {
            return
        }
        
        AF.request(url, method: .get, parameters: nil, headers: nil, interceptor: nil).response { (response) in
            guard let data = response.data else {return}
            
            do {
                let picture = try JSONDecoder().decode(ImageData.self, from: data)
                DispatchQueue.main.async {
                    self.delegate?.sendPictureData(picture: picture)
                }
            }catch{
                print(error.localizedDescription)
            }
        }.resume()
    }
}
