//
//  MultiMediaManager.swift
//  cameraApp
//
//  Created by shishir sapkota on 12/14/16.
//  Copyright © 2016 shishir sapkota. All rights reserved.
//

import Foundation
import UIKit

@objc protocol MultiMediaManagerDelegate {
     @objc optional func didFinishPickingWithImage(image: UIImage)
    @objc optional func didFinishPickingWithError(error: String)
}

class MultiMediaManager: NSObject {
    
    let imagePicker = UIImagePickerController()
    var viewController: UIViewController?
    var delegate: MultiMediaManagerDelegate?

    
    init(presentingViewController: UIViewController) {
        viewController = presentingViewController
        super.init()
        imagePicker.delegate = self
    }
    
    func showPictureSourceOptions(sender: UIButton? = nil) {

        var presentationStyle: UIAlertControllerStyle = .actionSheet
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad) {
            presentationStyle = .alert
        }
        
        let alertController = UIAlertController(title: "Image", message: "You can choose picture from gallery or you can take a selfie.", preferredStyle: presentationStyle)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { (action) in
            //open the camera to take a picture
            self.openCamera()
        }
//        let galleryAction = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.default) { (action) in
//            self.showPhotoGallery()
//        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alertController.addAction(galleryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        self.viewController?.present(alertController, animated: true, completion: nil)
    }
    
    
    func openCamera() {
        print("opening a camera...")
        self.imagePicker.sourceType = .camera
        self.viewController?.present(self.imagePicker, animated: true, completion: nil)
    }
    
    func showPhotoGallery(sender: UIButton? = nil) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        viewController?.present(imagePicker, animated: true, completion: nil)
    }
    
    // TODO: make profile view controller use this crop function.
    // used only in message view controller. profile does not implement this crop delegates. it handles it inside the profile view controlelr itself.
    
    
    
   }

extension MultiMediaManager: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        viewController?.dismiss(animated: true, completion: nil)
        if let picture = info[UIImagePickerControllerOriginalImage] as? UIImage {
           delegate?.didFinishPickingWithImage?(image: picture)
        }
        
    }
}

extension MultiMediaManager: UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        let vcCount = navigationController.viewControllers.count
        if vcCount == 2 {
            navigationController.viewControllers[0].navigationItem.title = ""
        } else if vcCount == 1 {
            navigationController.viewControllers[0].navigationItem.title = "Photos"
        }
    }
}

