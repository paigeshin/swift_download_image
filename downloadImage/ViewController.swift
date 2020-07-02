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

