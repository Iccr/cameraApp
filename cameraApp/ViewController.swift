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
    
    var text1 = "UM 216A"
    var textLocation = "longtitude" + "latitude"
    var textDate = "wow value at the end"
    
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
        locationManager.requestAlwaysAuthorization()
        btn.setTitle(NotificationMessages.RequestLocation.rawValue, for: .normal)
        imagePicker.delegate  = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        btn.set(title: "start")
    }
}

// pick the image.
extension ViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            self.textDate = Date().currentDateString()
            btn.set(title: "Start Boss!")
            self.dismiss(animated: true, completion: {
                guard let squareImage = image.getSqauredVersion(of: image, targetSize: CGSize(width: Konstants.imageWidth, height: Konstants.imageHeight)) else {
                    self.btn.set(title: NotificationMessages.SqaredImageFailed.rawValue)
                    return
                }
                
                // imageProcessing
                var image = squareImage
                image = squareImage.writeText(text: self.text1, at: Konstants.point1)
                image = image.writeText(text: self.textLocation, at: Konstants.point2)
                image = image.writeText(text: self.textDate, at: Konstants.point3)
                
                
                // create get the detail view controller
                let sb = UIStoryboard(name: StoryBoard.Detail.rawValue, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: Identifiers.detailViewController) as! DetailViewController
                vc.image = image
                self.navigationController?.pushViewController(vc, animated: true)
            })
        }
    }

    // called if the image picker failed to pick the image.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
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
        if let location = self.location {
            self.textLocation = location.toString()
        }
    }
    
    // called when location manager failed to update the location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
}
