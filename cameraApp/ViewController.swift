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
    
    var text1 = "wow value"
    var text2 = "longtitude" + "latitude"
    var text3 = "wow value at the end"
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

            
            
            self.dismiss(animated: true, completion: {
                guard let squareImage = self.getSqauredVersion(of: image) else {
                    self.btn.set(title: NotificationMessages.SqaredImageFailed.rawValue)
                    return
                }
                //
                let point = CGPoint(x: squareImage.size.width/2, y: squareImage.size.height/2)
                // i need three points here.
                
                
                let texedImage = self.textToImage(drawText: self.text1 as NSString, inImage: squareImage, atPoint: point )

                // create get the detail view controller
                let sb = UIStoryboard(name: StoryBoard.Detail.rawValue, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: Identifiers.detailViewController) as! DetailViewController
                vc.image = texedImage
                // self.push(inNavigation: vc)
                self.navigationController?.pushViewController(vc, animated: true)
            })
        }
    }
    
    
    private func generatePoints(from image: UIImage) -> (point1: Double, point2: Double, point03: Double) {
        let (height, width) = (image.size.height, image.size.width)
        
        
        return (3.2, 4.5, 5.5)
    }
    
    
    private func textToImage(drawText text: NSString, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        
        
        let textFont = UIFont(name: Konstants.font, size: Konstants.fontSize)!
        
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: Konstants.textColor,
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
        let height = image.size.height
        let width = image.size.width
        let size = width < height ? width : height
        
            return resizeImage(image: image, targetSize: CGSize(width: size, height: size))

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




struct Konstants {
    static let fontSize: CGFloat =  100
    static let font: String = "Helvetica Bold"
    static let textColor: UIColor = UIColor.white
}

struct Identifiers {
    static let detailViewController = "DetailViewController"
}
