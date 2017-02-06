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

    var sources = [PinterestItem]()
    override func viewDidLoad() {
        super.viewDidLoad()

        callService()
     Downloader.shared.download(url: "http://pastebin.com/raw/wgkJgazE", observer: self)
    }
    
    func downloaded(item: Any)
    {
        
    }
    func downloadFailed(forUrl url: String)
    {
        
    }
    func callService() {
        URLSession.shared.dataTask(with: URL(string: "http://pastebin.com/raw/wgkJgazE")!) { (data, response, error) in
            
            if let data = data {
                let results = JSON(data)
                if results.array != nil {
                    for object in results.array! {
                        let item = PinterestItem.init(json: object)
                        self.sources.append(item)
                    }
                }
            }// reload in ui thread
            self.tableView.reloadData()
        }.resume()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = sources[indexPath.row];
        let categories  = item.categories
        
        // Configure the cell...

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
