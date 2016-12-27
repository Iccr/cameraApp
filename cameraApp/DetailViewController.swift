//
//  DetailViewController.swift
//  cameraApp
//
//  Created by shishir sapkota on 12/14/16.
//  Copyright © 2016 shishir sapkota. All rights reserved.
//

import UIKit
import CoreLocation

class DetailViewController: UIViewController {

    var imgView: UIImageView?
    var image: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = self.image ?? UIImage()
        imgView = UIImageView(image: image)
        self.view = imgView
//        imageView.set(image: image)
        
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("UIimageView is \(imgView)")
        print("image is \(image)")
        guard let imgView = imgView else {return}
            imgView.image = image ?? UIImage()
    }
}
