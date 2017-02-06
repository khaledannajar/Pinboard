//
//  BoardTableViewController.swift
//  Pinboard
//
//  Created by khaledannajar on 2/4/17.
//  Copyright © 2017 mindvalley. All rights reserved.
//

import UIKit
import SwiftyJSON

class BoardTableViewController: UITableViewController, DownloadObserver {

    var pins = [PinterestItem]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callService()
    }
    
    func callService() {
        Downloader.shared.download(url: "http://pastebin.com/raw/wgkJgazE", observer: self)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
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
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

    }
    func downloadFailed(forUrl url: String)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        let alert = UIAlertController(title: "Error", message: "Failed with error", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
        })
        self.present(alert, animated: true) {}
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pins.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let pin = pins[indexPath.row];
        
        if let cell = cell as? PinTableViewCell {
//            cell.pinImageView.image
            cell.userNameLabel.text = pin.user?.name
        }
//        pin.user?.name
//        pin.user?.profileImage?.small
//        pin.urls?.small
        
        
        // Configure the cell...

        return cell
    }
}

class PinTableViewCell: UITableViewCell {
    @IBOutlet weak var pinImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
}
