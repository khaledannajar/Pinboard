//
//  PinsViewModel.swift
//  Pinboard
//
//  Created by khaledannajar on 2/7/17.
//  Copyright © 2017 mindvalley. All rights reserved.
//

import UIKit
import SwiftyJSON

class PinsViewModel: DownloadObserver {
    
    let notificationName = Notification.Name("com.mindvalley.pinsboard.pinsRetreived")
    
    var pins = [PinterestItem]()
    
    func callService() {
        Downloader.shared.download(url: "http://pastebin.com/raw/wgkJgazE", observer: self)
    }
    
    func downloaded(item: Data)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        let results = JSON(item)
        if results.array != nil {
            for object in results.array! {
                let item = PinterestItem.init(json: object)
                self.pins.append(item)
            }
            
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
        
    }
    
    func downloadFailed(forUrl url: String, error: Error) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        let userInfo:[String: Error] = ["error": error]
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: userInfo)
    }

}
