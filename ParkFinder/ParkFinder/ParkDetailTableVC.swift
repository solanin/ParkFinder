//
//  ParkDetailTableVC.swift
//  ParkFinder
//
//  Created by Jacob Westerback (RIT Student) on 4/5/17.
//  Copyright © 2017 Jacob Westerback (RIT Student). All rights reserved.
//

import UIKit
import MapKit

class ParkDetailTableVC: UITableViewController {
    
    // MARK: - Variables 

    var park:StatePark?
    let myNumSections = 7
    enum MySection: Int {
        case title = 0, address, description, favorite, viewOnMap, viewOnWeb, share
    }
    
    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return myNumSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "plainCell", for: indexPath)

        // Configure the cell...
        switch indexPath.section {
        case MySection.title.rawValue:
            cell.textLabel?.text = park?.title
            cell.textLabel?.textColor = UIColor.black
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
            cell.textLabel?.numberOfLines = 1
            cell.textLabel?.textAlignment = .left
            
        case MySection.address.rawValue:
            cell.textLabel?.text = (park?.county)! + "\n\n" + (park?.location)!
            cell.textLabel?.textColor = UIColor.black
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textAlignment = .left
            
        case MySection.description.rawValue:
            cell = tableView.dequeueReusableCell(withIdentifier: "resizeCell", for: indexPath)
            cell.textLabel?.text = park?.summary
            cell.textLabel?.textColor = UIColor.black
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textAlignment = .left
            
            
        case MySection.favorite.rawValue:
            cell.textLabel?.text = (park?.isFavorite)! ? "Unfavorite" : "Favorite"
            cell.textLabel?.textColor = view.tintColor
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
            cell.textLabel?.numberOfLines = 1
            cell.textLabel?.textAlignment = .center
            
        case MySection.viewOnMap.rawValue:
            cell.textLabel?.text = "View on Map"
            cell.textLabel?.textColor = view.tintColor
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
            cell.textLabel?.numberOfLines = 1
            cell.textLabel?.textAlignment = .center
            
        case MySection.viewOnWeb.rawValue:
            cell.textLabel?.text = "View on Web"
            if URL(string: (park?.link)!) != nil{
                cell.textLabel?.textColor = view.tintColor
            } else {
                cell.textLabel?.textColor = UIColor.gray
            }
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
            cell.textLabel?.numberOfLines = 1
            cell.textLabel?.textAlignment = .center
            
        case MySection.share.rawValue:
            cell.textLabel?.text = "Share"
            cell.textLabel?.textColor = view.tintColor
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
            cell.textLabel?.numberOfLines = 1
            cell.textLabel?.textAlignment = .center
            
        default:
            cell.textLabel?.text = "TBD"
        }

        return cell
    }
    /*
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == MySection.title.rawValue {
            return 54.0
        }
        
        if indexPath.section == MySection.description.rawValue {
            return 200.0
        }
        
        return 44.0
    }*/

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("Favorite tapped : \(park?.isFavorite)")
        if indexPath.section == MySection.favorite.rawValue {
            if (park != nil) {
                ParkData.sharedData.toggleFavorite(park: park!)
                tableView.reloadData()
            }
        }
        
        if indexPath.section == MySection.viewOnMap.rawValue {
            //print("View on Map tapped")
            let data = ["park":park]
            NotificationCenter.default.post(name: viewOnMapNotificaiton, object: self, userInfo:data)
        }
        
        if indexPath.section == MySection.viewOnWeb.rawValue {
            //print("View on Web tapped")
            if let url = URL(string: (park?.link)!){
                UIApplication.shared.open(
                    url,
                    options:[:],
                    completionHandler: {
                        (success) in
                        print("Open \(url.description) - success = \(success)")
                }
                )
            }
        }
        
        if indexPath.section == MySection.share.rawValue {
            //print("Share tapped")
            let textToShare = park?.title
            let site = NSURL(string: (park?.link)!)
            let objectToShare:[AnyObject] = [textToShare as AnyObject, site!]
            let activityVC = UIActivityViewController(activityItems: objectToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityType.print]
            activityVC.modalPresentationStyle = UIModalPresentationStyle.popover
            activityVC.popoverPresentationController?.sourceView = self.view
            activityVC.popoverPresentationController?.permittedArrowDirections = .any
            self.present(activityVC, animated: true, completion: nil)
        }
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
