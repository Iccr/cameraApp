//
//  ViewController.swift
//  cameraApp
//
//  Created by shishir sapkota on 12/14/16.
//  Copyright © 2016 shishir sapkota. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var btn: UIButton!
    
    
    @IBAction func btnStart(_ sender: Any) {
        locationManager.requestLocation()
        btn.set(title: "requesting location...")
    }
    
    var location: CLLocationCoordinate2D?
    var locationManager: CLLocationManager!
    var imagePicker = UIImagePickerController()
    var isPresented: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        btn.setTitle(NotificationMessages.RequestLocation.rawValue, for: .normal)
        imagePicker.delegate  = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        btn.set(title: "start")
    }
   
}



// Location
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // show the camera options.
        self.location = locations.last?.coordinate
        imagePicker.sourceType = .camera
        if !isPresented {
            self.present(imagePicker, animated: true, completion: nil)
            isPresented = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
}


// Camera
extension ViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let date = Date()
            let formatter = DateFormat.standard.dateFormatter.string(from: date)
            btn.set(title: "Start Boss!")
//            lblNotify.set(text: "image processing")
            
            // post imageProcessing
            var sb = UIStoryboard(name: StoryBoard.Detail.rawValue, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            
            
            self.dismiss(animated: true, completion: {
                guard let squareImage = self.getSqauredVersion(of: image) else {
                    self.btn.set(title: NotificationMessages.SqaredImageFailed.rawValue)
                    return
                }
                //
                let texedImage = self.textToImage(drawText: "Wow", inImage: squareImage, atPoint: CGPoint(x: squareImage.size.width/2, y: squareImage.size.height/2))
//                let texedImage = self.textToImage(drawText: "Wow", inImage: squareImage, atPoint: CGPoint(x: squareImage.size.width/2, y: squareImage.size.height/2))
                vc.image = texedImage
                // self.push(inNavigation: vc)
                self.navigationController?.pushViewController(vc, animated: true)
            })
        }
    }
    
    private func textToImage(drawText text: NSString, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        
        let textColor = UIColor.white
        let textFont = UIFont(name: "Helvetica Bold", size: 12)!
        
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            ] as [String : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func getSqauredVersion(of  image: UIImage) -> UIImage? {
        // _sender is present if this was called from the messageViewController.
        let size = image.size.width > image.size.height ? image.size.width : image.size.height
        
            return resizeImage(image: image, targetSize: CGSize(width: 600, height: 600))

    }
    
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let newSize = CGSize(width: targetSize.width, height: targetSize.height)
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        print("image resized")
        return newImage
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
}

extension ViewController: UINavigationControllerDelegate {

}

extension UIButton {
    func set(title: String) {
        self.setTitle(title, for: .normal)
    }
}

extension UIViewController {
    func push(inNavigation controller: UIViewController) {
        self.navigationController?.pushViewController(controller, animated: true)
    }
}


enum DateFormat: String {
    case standard = "yyyy/MM/dd HH:mm"
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.default
        dateFormatter.dateFormat = self.rawValue
        return dateFormatter
    }
}

enum StoryBoard: String {
    case Detail = "Detail"
}

enum NotificationMessages: String {
    case RequestLocation = "Requesting Location..."
    case SqaredImageFailed = "Failed to convert image to required size"
}

