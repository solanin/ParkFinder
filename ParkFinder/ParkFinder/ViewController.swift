//
//  ViewController.swift
//  ParkFinder
//
//  Created by Jacob Westerback (RIT Student) on 3/31/17.
//  Copyright © 2017 Jacob Westerback (RIT Student). All rights reserved.
//

import UIKit
import MapKit

// MARK: - Global Notification Variables -

let viewOnMapNotificaiton = NSNotification.Name("viewOnMapNotificaiton")
let viewOnListNotificaiton = NSNotification.Name("viewOnListNotificaiton")
let favoritesChangedNotification = NSNotification.Name("favoritesChangedNotification")

class ViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Variables
    
    @IBOutlet weak var mapView: MKMapView!
    let metersPerMile:Double = 1609.344
    let fileName = "parks.archive"
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        
        //Notificaiton Listening
        NotificationCenter.default.addObserver(self, selector: #selector(showMap), name: viewOnMapNotificaiton, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveParks), name: favoritesChangedNotification, object: nil)
        let parksTableVC:ParksTableVC = tabBarController!.viewControllers![1].childViewControllers[0] as! ParksTableVC
        let parksFavTableVC:ParksFavTableVC = tabBarController!.viewControllers![2].childViewControllers[0] as! ParksFavTableVC
        NotificationCenter.default.addObserver(parksTableVC, selector: #selector(parksTableVC.showDetail), name: viewOnListNotificaiton, object: nil)
        NotificationCenter.default.addObserver(parksFavTableVC, selector: #selector(parksFavTableVC.reload), name: favoritesChangedNotification, object: nil)
        NotificationCenter.default.addObserver(parksTableVC, selector: #selector(parksTableVC.reload), name: favoritesChangedNotification, object: nil)
        
        // Load Data
        let pathToFile = FileManager.filePathInDocumentsDirectory(fileName:fileName)
        if FileManager.default.fileExists(atPath: pathToFile.path){
            //print("Opened \(pathToFile)")
            let tempparks = NSKeyedUnarchiver.unarchiveObject(withFile: pathToFile.path) as! [StatePark]
            //print("Fav Parks = \(tempparks)")
            ParkData.sharedData.setParks(newParks: tempparks)
        } else {
            print("Could not find \(pathToFile)")
            loadData()
        }
        saveParks()
        
        // Setup
        mapView.addAnnotations(ParkData.sharedData.allParks)
        let centerNY = CLLocationCoordinate2D(latitude: 43.100903, longitude: -75.232664)
        let myRegion = MKCoordinateRegionMakeWithDistance(centerNY, metersPerMile * 400, metersPerMile * 400)
        mapView.setRegion(myRegion, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Methods
    
    func saveParks() {
        let pathToFile = FileManager.filePathInDocumentsDirectory(fileName: fileName)
        /*let success = */NSKeyedArchiver.archiveRootObject(ParkData.sharedData.allParks, toFile: pathToFile.path)
        //print("Saved = \(success)") // to \(pathToFile)")
    }
    
    func loadData() {
        guard let path = Bundle.main.url(forResource: "parks", withExtension: "js") else {
            print ("Error: Could not find parks.js")
            return
        }
        do {
            let data = try Data(contentsOf: path, options:[])
            let json = JSON(data:data)
            if (json != JSON.null) {
                parse(json:json)
            } else {
                print ("Error: json is null")
            }
        } catch {
            print("Error: Could not initialize the Data() object")
        }
    }
    
    func parse(json:JSON) {
        let array = json["parks"].arrayValue
        var parks = [StatePark]()
        
        for d in array {
            var name = d["name"].stringValue
            if name.isEmpty {
                name = "Unamed Park"
            }
            
            let latitude = d["latitude"].floatValue
            let longitude = d["longitude"].floatValue
            let url = d["url"].stringValue
            let address = d["address"].stringValue
            let description = d["description"].stringValue
            
            var area = d["county"].stringValue
            if area.isEmpty {
                area = "New York State"
            }
            
            let park = StatePark(name: name, latitude: latitude, longitude: longitude, url: url, address: address, desc: description, area:area)
            parks.append(park)
        }
        
        // Save
        ParkData.sharedData.setParks(newParks: parks)
    }
    
    // MARK: - MKMapViewDelegate Protocal Methods
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //print("Tapped \(title!)")
        //let title = view.annotation?.title ?? "Unamed Park"
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation)  -> MKAnnotationView? {
        guard let annotation = annotation as? StatePark else {
            print("This annotation is not a StatePark")
            return nil
        }
        
        // Set up info button
        let identifier = "pinIdentifier"
        let view:MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
    
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? StatePark else {
            print("This annotation is not a StatePark")
            return
        }
        
        //print ("Tapped info button for \(annotation.description)")
        let data = ["park":annotation]
        NotificationCenter.default.post(name: viewOnListNotificaiton, object: self, userInfo:data)
        tabBarController?.selectedIndex = 1
        //print ("Sent \(viewOnListNotificaiton)")
    }
    
    // MARK: - Notifications
    
    func showMap (notification:NSNotification) {
        tabBarController?.selectedIndex = 0
        if let park = notification.userInfo!["park"] as? MKAnnotation {
            mapView.selectAnnotation(park, animated: true)
        }
    }
}

