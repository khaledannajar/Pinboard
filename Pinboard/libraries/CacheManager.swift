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
    static let shared = CacheManager(configs: CacheConfigs.default())
    
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
    
    func set(url: String, item: Data) {
        var cachedItem = cached[url]
        if cachedItem == nil {
            cachedItem = CachedItem(url: url, item: item)
            cached[url] = cachedItem
        }
    }
    
    func getItem(url: String) -> Data? {
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
    private let item: Data
    
    private let createdTime: Date
    private(set) public var requestedTimes: Int = 0
    
    init(url: String, item: Data) {
        self.url = url
        self.item = item
        self.createdTime = Date()
    }
    
    func getItem() -> Data{
        requestedTimes += 1
        return item
    }
    
}
