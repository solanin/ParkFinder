//
//  ParksTableVC.swift
//  ParkFinder
//
//  Created by Jacob Westerback (RIT Student) on 3/31/17.
//  Copyright © 2017 Jacob Westerback (RIT Student). All rights reserved.
//

import UIKit

class ParksTableVC: UITableViewController, UISearchResultsUpdating {
    
    // MARK: - Variables

    var park:StatePark?
    var filteredParks:[StatePark] = [StatePark]()
    let searchController = UISearchController(searchResultsController: nil)
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredParks = ParkData.sharedData.allParks.filter { park in
            return park.parkName.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        title = "Parks"
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - MySearchResultsUpdating Methods
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredParks.count
        }
        return ParkData.sharedData.allParks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "reuseIdentifier")
        //cell.accessoryType = .disclosureIndicator
        
        let park:StatePark
        
        if searchController.isActive && searchController.searchBar.text != "" {
            park = filteredParks[indexPath.row]
        } else {
            park = ParkData.sharedData.allParks[indexPath.row]
        }
        
        // Configure the cell...
        cell.textLabel?.text = park.title
        if (park.isFavorite) {
            cell.textLabel?.text = "★ " + (cell.textLabel?.text)!
        }
        
        cell.detailTextLabel?.text = park.county
        
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let indexPath = tableView.indexPathForSelectedRow {
            let selectedRow = indexPath.row
            guard selectedRow < ParkData.sharedData.allParks.count else {
                print("row \(selectedRow) is not in Parks!")
                return
            }
            let detailVC = segue.destination as! ParkDetailTableVC
            detailVC.park = ParkData.sharedData.allParks[selectedRow]
        } else if (park != nil) {
            guard ParkData.sharedData.allParks.contains(park!) else {
                print("\(park) is not in Parks!")
                return
            }
            let detailVC = segue.destination as! ParkDetailTableVC
            detailVC.park = park
        }
    }
    
    // MARK: - Notifications
    
    func showDetail (notification:NSNotification) {
        //print ("Recived \(notification)")
        if let selectedPark = notification.userInfo!["park"] as? StatePark {
            park = selectedPark
            performSegue(withIdentifier: "goToDetail", sender: nil)
        }
    }
    
    func reload() {
        tableView.reloadData()
    }

}
