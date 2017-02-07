//
//  BoardTableViewController.swift
//  Pinboard
//
//  Created by khaledannajar on 2/4/17.
//  Copyright © 2017 mindvalley. All rights reserved.
//

import UIKit
import SwiftyJSON

class BoardTableViewController: UITableViewController {

    let notificationName = Notification.Name("com.mindvalley.pinsboard.pinsRetreived")
    
    var pins = [PinterestItem]()
    let pinsViewModel = PinsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pinsViewModel.callService()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: notificationName, object: nil)
    }
    
    func updateUI(_ notification: NSNotification) {
        
        if let error = notification.userInfo?["error"] as? NSError {
            Helper.displayAlert(title: "Error", message: "Failed with error \(error.localizedDescription)", inViewController: self)
            return
        }
        
        self.pins = pinsViewModel.pins
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
        
        //TODO: simplify this
        if let cell = cell as? PinTableViewCell {
            cell.pinImageView.image = UIImage(named: "placeholder")
            
            if pin.urls?.small != nil {
                Downloader.shared.download(url: (pin.urls?.small)!, successBlock: { (data) in
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        
                        UIView.transition(with: cell.pinImageView,
                                          duration: 0.9,
                                          options: .transitionCrossDissolve,
                                          animations: {
                                            cell.pinImageView.image = image
                        },
                                          completion: nil)
                    }
                }, failureBlock: { (error) in
                    print("downloading image with url:\(pin.urls?.small) error: \(error)")
                })
            }
            
            cell.userNameLabel.text = pin.user?.name
        }
//        pin.user?.name
//        pin.user?.profileImage?.small
//        pin.urls?.small
        

        return cell
    }
}

class PinTableViewCell: UITableViewCell {
    @IBOutlet weak var pinImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
}
