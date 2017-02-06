//
//  Downloader.swift
//  Pinboard
//
//  Created by khaledannajar on 2/3/17.
//  Copyright © 2017 mindvalley. All rights reserved.
//

import Foundation

protocol DownloadObserver {
    func downloaded(item: Any)
    func downloadFailed(forUrl url: String)
}
enum DownloadState {
    case none, pending, waiting, started, finished, failed
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
        if downloadItem != nil {
            if downloadItem!.state == .pending {
                return
            }
        } else {
            downloadItem = DownloadItem(url: url, observer: observer)
            self.downloads[url] =  downloadItem
            
            doDownload(downloadItem: downloadItem!)
        }
    }
    
    private func deliverFromCache(url: String, observer: DownloadObserver) -> Bool {
        let downloadedItem = cacheManager.getItem(url: url)
        if downloadedItem != nil {
            observer.downloaded(item: downloadedItem!)
            return true
        }
        return false
    }
    
    private func doDownload (downloadItem: DownloadItem) {
        
    }
}

class DownloadItem {
    private(set) public var state: DownloadState = .none
    private var observers = [DownloadObserver]()
    private var url: String
    private var downloadedItem: Any?
    
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
    
    fileprivate func change(downloadState: DownloadState) {
        switch downloadState {
        case .failed:
            notifyFailure()
            break
        case .finished:
            notifySuccess()
            break
            // for now we won't do a thing in these states may be helpful in cancelling
        case .none:
            break
        case .pending:
            break
        case .started:
            break
        case .waiting:
            break
        }
        self.state = downloadState
    }
    func notifySuccess() {
        guard downloadedItem != nil else {
            notifyFailure()
            return
        }
        
        for observer in observers {
            observer.downloaded(item: downloadedItem!)
        }
    }
    func notifyFailure()
    {
        for observer in observers {
            observer.downloadFailed(forUrl: url)
        }
    }
}

