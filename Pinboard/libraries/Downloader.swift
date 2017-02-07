//
//  Downloader.swift
//  Pinboard
//
//  Created by khaledannajar on 2/3/17.
//  Copyright © 2017 mindvalley. All rights reserved.
//

import Foundation

protocol DownloadObserver: class {
    func downloaded(item: Data)
    func downloadFailed(forUrl url: String, error: Error)
}
enum DownloadState {
    case none, pending, finished, failed
}

class Downloader {
    static let shared = Downloader()
    let cacheManager = CacheManager(configs: CacheConfigs.default())
    
    
    private var downloads = [String : DownloadItem]()
    
    func download(url: String, observer: DownloadObserver) {
        
        let item = itemFromCache(url: url)
        if item != nil {
            observer.downloaded(item: item!)
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
    
    func download(url: String,successBlock: @escaping (Data) ->(), failureBlock: @escaping (Error?) ->()) {
        let item = itemFromCache(url: url)
        if item != nil {
            successBlock(item!)
            return
        }
       
        var downloadItem = self.downloads[url]
        
        if downloadItem == nil {
            let notifier = ClosureNotifier(successBlock: successBlock, failureBlock: failureBlock)
            downloadItem = DownloadItem(url: url, closureNotifier: notifier)
        }
        
        if downloadItem!.state == .pending {
            return
        }
        
        self.downloads[url] =  downloadItem
        
        doDownload(downloadItem: downloadItem!)
    }
    
    private func itemFromCache(url: String) -> Data? {
        let cachedItem = cacheManager.getItem(url: url)
        return cachedItem
    }
    
    private func doDownload (downloadItem: DownloadItem) {
        
        let dataTask = URLSession.shared.dataTask(with: URL(string: downloadItem.url)!) { (data, response, error) in
            
            defer {
                self.downloads.removeValue(forKey: downloadItem.url)
            }
            
            if error != nil {
                downloadItem.notifyFailure(error: error!)
                return
            }
            
            guard data != nil else {
                
                let emptyError = self.createEmptyDataError()

                downloadItem.notifyFailure(error: emptyError)
                return
            }
            
            downloadItem.notifySuccess(data: data!)
            self.cacheManager.set(url: downloadItem.url, item: data!)
        }
        
        dataTask.resume()
        
        downloadItem.downloadTask = dataTask
        downloadItem.state = .pending
    }
    
    func cancelDownload(url: String, observer: DownloadObserver) {
        let downloadItem = downloads[url]
        if downloadItem != nil {
            downloadItem?.removeObserver(observerToRemove: observer)
            if downloadItem?.observers.count == 0 {
                
                let safeToCancelBlocks = downloadItem?.blocksObservers.count == 0 || downloadItem?.blocksObservers.count == 1
                let noObjectObservers = downloadItem?.observers.count == 0
                
                if noObjectObservers && safeToCancelBlocks {
                    downloadItem?.downloadTask?.cancel()
                    downloads.removeValue(forKey: downloadItem!.url)
                }
            }
        }
    }
    //TODO: move to a helper class
    func createEmptyDataError() -> NSError {
        let userInfo: [NSObject : AnyObject] =
            [
                NSLocalizedDescriptionKey as NSObject :  NSLocalizedString("Empty Data", value: "Url response was empty", comment: "") as AnyObject,
                NSLocalizedFailureReasonErrorKey as NSObject : NSLocalizedString("Empty Data", value: "Url response was empty", comment: "") as AnyObject
        ]
        let emptyError = NSError(domain: "DownloaderResponseErrorDomain", code: 200, userInfo: userInfo)

        return emptyError
    }
}

class DownloadItem {
    var state: DownloadState = .none
    private(set) public var downloadedItem: Data?
    var observers = [DownloadObserver]()
    var blocksObservers = [ClosureNotifier]()
    
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
    
    init(url: String, closureNotifier: ClosureNotifier) {
        self.url = url
        self.blocksObservers.append(closureNotifier)
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
        
        for blockNotifier in blocksObservers {
            blockNotifier.successBlock(data)
        }
        finalize()
    }
    
    func notifyFailure(error: Error)
    {
        self.state = .failed
        for observer in observers {
            observer.downloadFailed(forUrl: url, error: error)
        }
        
        for blockNotifier in blocksObservers {
            blockNotifier.failureBlock(error)
        }
        
        finalize()
    }
    
    func finalize() {
        observers.removeAll()
        blocksObservers.removeAll()
    }
}

class ClosureNotifier: NSObject {
    var successBlock: (Data) ->()
    var failureBlock: (Error?) ->()
    init(successBlock: @escaping (Data) ->(), failureBlock: @escaping (Error?) ->()) {
        self.successBlock = successBlock
        self.failureBlock = failureBlock
    }
}
