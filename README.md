# swift_download_image

[https://programmingwithswift.com/save-images-locally-with-swift-5/](https://programmingwithswift.com/save-images-locally-with-swift-5/)

- Image Handler

```swift
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
```

- apply to viewController

```swift
//
//  ViewController.swift
//  downloadImage
//
//  Created by shin seunghyun on 2020/07/02.
//  Copyright © 2020 shin seunghyun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let imageHandler: ImageHandler = ImageHandler()

    @IBOutlet weak var imageToSaveImageView: UIImageView! {
        didSet {
            imageToSaveImageView.image = UIImage(named: "building")
        }
    }
    
    @IBOutlet weak var saveImageButton: UIButton! {
        didSet {
            saveImageButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var savedImageDisplayImageView: UIImageView!
    
    @IBOutlet weak var displaySaveImageButton: UIButton! {
        didSet {
            displaySaveImageButton.addTarget(self, action: #selector(display), for: .touchUpInside)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @objc func save() {
        if let buildingImage = UIImage(named: "building") {
            DispatchQueue.global(qos: .background).async {
                self.imageHandler.store(image: buildingImage,
                            forKey: "buildingImage",
                            withStorageType: .fileSystem)
            }
        }
    }
    
    @objc
    func display() {
        DispatchQueue.global(qos: .background).async {
            if let savedImage = self.imageHandler.retrieveImage(forKey: "buildingImage",
                                                                inStorageType: .fileSystem) {
                DispatchQueue.main.async {
                    self.savedImageDisplayImageView.image = savedImage
                }
            }
        }
    }

}
```

### UserDefaults에 Object를 저장할 수 있다.

- 가져오는 방법

```swift
if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
    let image: UIImage = UIImage(data: imageData) {
      return image
}
```

# FileManager

- A file manager object lets you examine the contents of the file system and make changes to it. The `FileManager` class provides convenient access to a shared file manager object that is suitable for most types of file-related manipulations. A file manager object is typically your primary mode of interaction with the file system. You use it to locate, create, copy, and move files and directories. You also use it to get information about a file or directory or change some of its attributes.
- When specifying the location of files, you can use either `NSURL` or `NSString` objects. The use of the `[NSURL](https://developer.apple.com/documentation/foundation/nsurl)` class is generally preferred for specifying file-system items because URLs can convert path information to a more efficient representation internally. You can also obtain a bookmark from an `NSURL` object, which is similar to an alias and offers a more sure way of locating the file or directory later.
- If you are moving, copying, linking, or removing files or directories, you can use a delegate in conjunction with a file manager object to manage those operations. The delegate’s role is to affirm the operation and to decide whether to proceed when errors occur. In macOS 10.7 and later, the delegate must conform to the `[FileManagerDelegate](https://developer.apple.com/documentation/foundation/filemanagerdelegate)` protocol.
- In iOS 5.0 and later and in macOS 10.7 and later, `FileManager` includes methods for managing items stored in iCloud. Files and directories tagged for cloud storage are synced to iCloud so that they can be made available to the user’s iOS devices and Macintosh computers. Changes to an item in one location are propagated to all other locations to ensure the items stay in sync.

# **Threading Considerations**

The methods of the shared `FileManager` object can be called from multiple threads safely. However, if you use a delegate to receive notifications about the status of move, copy, remove, and link operations, you should create a unique instance of the file manager object, assign your delegate to that object, and use that file manager to initiate your operations.
