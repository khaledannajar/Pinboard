//
//  CacheManager.swift
//  Pinboard
//
//  Created by khaledannajar on 2/4/17.
//  Copyright © 2017 mindvalley. All rights reserved.
//

import Foundation


class CacheConfigs {
    var maxItems: Int = 50
    var cleanUpPeriod: TimeInterval = 5 * 60
    
    class func `default`() -> CacheConfigs {
        return CacheConfigs()
    }
}
class CacheManager {
    let shared = CacheManager(configs: CacheConfigs())
    
    var configs: CacheConfigs
    private var cached = [String : CachedItem]()
    var maxItemsCount: Int
    
    init(configs: CacheConfigs) {
        
        self.configs = configs
        self.maxItemsCount = configs.maxItems
        
        if configs.cleanUpPeriod != 0 {
            Timer.scheduledTimer(withTimeInterval: configs.cleanUpPeriod, repeats: true) { (timer) in
                self.releaseResources()
            }
        }
    }
    
    func getItem(url: String) -> Any? {
        return cached[url]?.getItem()
    }
    
    func releaseResources() {
        if cached.count == configs.maxItems {
            
            var leastRequestedKey: String?
            var leastRequestedTimes: Int = Int.max
            for itemKey in cached.keys {
                if let cacheditem = cached[itemKey] {
                    if cacheditem.requestedTimes < leastRequestedTimes {
                        leastRequestedKey = itemKey
                        leastRequestedTimes = cacheditem.requestedTimes
                    }
                }
            }
            
            if leastRequestedKey != nil {
                cached.removeValue(forKey: leastRequestedKey!)
            }
        }
    }
}

class CachedItem {
    private let url: String
    private let item: Any
    
    private let createdTime: Date
    private(set) public var requestedTimes: Int = 0
    
    init(url: String, item: Any) {
        self.url = url
        self.item = item
        self.createdTime = Date()
    }
    
    func getItem() -> Any{
        requestedTimes += 1
        return item
    }
    
}
