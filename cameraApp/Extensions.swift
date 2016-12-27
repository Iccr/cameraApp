//
//  Extensions.swift
//  cameraApp
//
//  Created by shishir sapkota on 12/21/16.
//  Copyright © 2016 shishir sapkota. All rights reserved.
//

import UIKit
import CoreLocation

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

extension CLLocationCoordinate2D {
    func toString() -> String {
        return "\(self.latitude)" + ", " + "\(self.longitude)"
    }
}

extension UIImageView {
    func set(image: UIImage?) {
        self.image = image ?? UIImage()
    }
}


extension Int {
    func toFloat() -> CGFloat {
        var scale:CGFloat = 1

        return CGFloat(self) * scale
    }
}

extension UIImage {
    func writeText(text: String, at estimatedPoint: CGPoint) -> UIImage {
        
        let textFont = UIFont(name: Konstants.font, size: Konstants.fontSize)!
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(self.size, false, scale)
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: Konstants.textColor,
            ] as [String : Any]
        self.draw(in: CGRect(origin: CGPoint.zero, size: self.size))
        // adjust the text position.
        
        
        
        let size: CGSize = CGSize(width: Konstants.imageWidth, height: Konstants.imageHeight)
        
        let boundingRect = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: textFontAttributes, context: nil)
        let x = estimatedPoint.x - boundingRect.width - Konstants.textPadding
        let origin = CGPoint(x: x, y: estimatedPoint.y)
        let myRect = CGRect(origin: origin, size: self.size)
        
        text.draw(in: myRect, withAttributes: textFontAttributes)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

}

extension String {
    func length() -> Int {
        return self.characters.count
    }
}


extension ViewController: UINavigationControllerDelegate {
    
}

extension Date  {
    func currentDateString() -> String {
        return DateFormat.standard.dateFormatter.string(from: self)
    }
}

extension UIImage {
    func getSqauredVersion(of  image: UIImage, targetSize: CGSize) -> UIImage? {
        let newSize = CGSize(width: targetSize.width, height: targetSize.height)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

