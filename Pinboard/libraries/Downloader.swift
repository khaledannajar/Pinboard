//
//  Downloader.swift
//  Pinboard
//
//  Created by khaledannajar on 2/3/17.
//  Copyright © 2017 mindvalley. All rights reserved.
//

import Foundation

protocol DownloadObserver: class {
    typealias Model = NSObject
    func downloaded(item: Data)
    func downloadFailed(forUrl url: String)
}
enum DownloadState {
    case none, pending, finished, failed
}

class Downloader {
    static let shared = Downloader()
    let cacheManager = CacheManager(configs: CacheConfigs.default())
    
    
    private var downloads = [String : DownloadItem]()
    
    func download(url: String, observer: DownloadObserver) {
        
        if deliverFromCache(url: url, observer: observer) {
            return
        }
        
        var downloadItem = self.downloads[url]
        
        if downloadItem == nil {
            downloadItem = DownloadItem(url: url, observer: observer)
        }
        
        if downloadItem!.state == .pending {
            return
        }
        
        self.downloads[url] =  downloadItem
        
        doDownload(downloadItem: downloadItem!)
        
    }
    
    private func deliverFromCache(url: String, observer: DownloadObserver) -> Bool {
        let cachedItem = cacheManager.getItem(url: url)
        if cachedItem != nil {
            observer.downloaded(item: cachedItem!)
            return true
        }
        return false
    }
    
    private func doDownload (downloadItem: DownloadItem) {
        
        let dataTask = URLSession.shared.dataTask(with: URL(string: downloadItem.url)!) { (data, response, error) in
            
            guard data != nil else {
                downloadItem.notifyFailure()
                return
            }
            downloadItem.notifySuccess(data: data!)
            
        }
        dataTask.resume()
        
        downloadItem.downloadTask = dataTask
        downloadItem.state = .pending
    }
    
    func cancelDownload(url: String, observer: DownloadObserver) {
        let downloadItem = downloads[url]
        if downloadItem != nil {
            downloadItem?.downloadTask?.cancel()
        }
    }
}

class DownloadItem {
    var state: DownloadState = .none
    private(set) public var downloadedItem: Data?
    private var observers = [DownloadObserver]()
    var url: String
    var downloadTask: URLSessionDataTask?
    
    init(url: String, observer: DownloadObserver) {
        self.url = url
        self.observers.append(observer)
    }
    
    init(url: String, observers: [DownloadObserver]) {
        self.url = url
        self.observers.append(contentsOf: observers)
    }
    
    func add(observer: DownloadObserver) {
        observers.append(observer)
        // may check for status and if already downloaded update observer
        // second thought check status if
    }
    
    func removeObserver(observerToRemove: DownloadObserver) {
        for (index, observer) in self.observers.enumerated() {
            if observer === observerToRemove {
                self.observers.remove(at: index)
            }
        }
    }
    func notifySuccess(data: Data) {
        downloadedItem = data
        self.state = .finished
        
        for observer in observers {
            observer.downloaded(item: downloadedItem!)
        }
    }
    func notifyFailure()
    {
        self.state = .failed
        for observer in observers {
            observer.downloadFailed(forUrl: url)
        }
    }
}

