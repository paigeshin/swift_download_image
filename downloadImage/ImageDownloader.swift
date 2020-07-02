//
//  ImageDownloader.swift
//  downloadImage
//
//  Created by shin seunghyun on 2020/07/02.
//  Copyright © 2020 shin seunghyun. All rights reserved.
//

import UIKit

enum StorageType {
    case userDefaults
    case fileSystem
}

class ImageHandler {
    
    func store(image: UIImage, forKey key: String, withStorageType storageType: StorageType) {
        if let pngRepresentation = image.pngData() {
            switch storageType {
            case .fileSystem:
                if let filePath = filePath(forKey: key) {
                    do {
                        try pngRepresentation.write(to: filePath, options: .atomic)
                    } catch let err {
                        print("Saving file resulted in error: ", err)
                    }
                }
            case .userDefaults:
                UserDefaults.standard.set(pngRepresentation, forKey: key)
            }
        }
    }
    
    func retrieveImage(forKey key: String, inStorageType storageType: StorageType) -> UIImage? {
        switch storageType {
        case .fileSystem:
            /*
                1. Path를 가져옴
                2. Path로 데이터를 가져옴
             */
            if let filePath: URL = self.filePath(forKey: key),
                let fileData: Data = FileManager.default.contents(atPath: filePath.path),
                let image: UIImage = UIImage(data: fileData) {
                return image
            }
        case .userDefaults:
            if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
                let image: UIImage = UIImage(data: imageData) {
                  return image
            }
        }
        return nil
        
    }
        
    private func filePath(forKey key: String) -> URL? {
        let fileManager: FileManager = FileManager.default
        guard let documentURL = fileManager.urls(
            for: .documentDirectory,
            in: FileManager.SearchPathDomainMask.userDomainMask).first
        else { return nil }
        return documentURL.appendingPathComponent(key + ".png")
    }
    
}
