//
//  Enum.swift
//  cameraApp
//
//  Created by shishir sapkota on 12/21/16.
//  Copyright © 2016 shishir sapkota. All rights reserved.
//

import Foundation
import  UIKit

enum DateFormat: String {
    case standard = "d MMM yyyy, h:mm:ss a"
    
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

enum TextSize: CGFloat {
    case date = 39
    case location = 40
    
    case title = 50
}
