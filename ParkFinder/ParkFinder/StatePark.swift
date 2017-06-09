//
//  StatePark.swift
//  ParkFinder
//
//  Created by Jacob Westerback (RIT Student) on 3/31/17.
//  Copyright © 2017 Jacob Westerback (RIT Student). All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

public class StatePark:NSObject,MKAnnotation,NSCoding {
    // MARK: - Variables
    
    private var name:String
    private var latitude:Float
    private var longitude:Float
    private var url:String
    private var address:String
    private var desc:String
    private var fav:Bool
    private var id:String
    public var index:Int32
    private var area:String
    
    // MARK: - MKAnnotation Protocalls
    
    public var title:String? {
        return parkName
    }
    public var subtitle: String? {
        return county
    }
    
    // MARK: - Accessors
    
    public var parkName:String {
        return name
    }
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longitude))
    }
    public var link:String {
        return url
    }
    public var location:String {
        return address
    }
    public var summary:String {
        return desc
    }
    public var isFavorite:Bool {
        return fav
    }
    public var uniqueID:String {
        return id
    }
    public var favIndex:Int32 {
        return index
    }
    public var county:String {
        return area
    }
    
    // MARK: - Initialization
    
    convenience init(name:String, latitude:Float, longitude:Float, url:String, address:String, desc:String, area:String) {
        self.init(name: name, latitude: latitude, longitude: longitude, url: url, address: address, desc: desc, fav: false, area:area)
    }
    
    init(name:String, latitude:Float, longitude:Float, url:String, address:String, desc:String, fav:Bool, area:String) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.url = url
        self.address = address
        self.desc = desc
        self.fav = fav
        self.id = ""
        self.index = 0
        self.area = area
        super.init()
        self.id = randomString(length: 20)
    }
    
    // MARK: - Helper Methods
    
    // Creates a random string used as an identifier
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    public override var description: String {
        return "\(name) : (\(latitude),\(longitude))"
    }
    
    public func toggleFavorite() {
        fav = !fav
        //print("Favorite Toggled; \(name) is now: \(fav)")
    }
    
    // MARK: - NSCoding Protocal Methods
    
    required public init(coder aDecoder:NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        latitude = aDecoder.decodeFloat(forKey: "latitude")
        longitude = aDecoder.decodeFloat(forKey: "longitude")
        url = aDecoder.decodeObject(forKey: "url") as! String
        address = aDecoder.decodeObject(forKey: "address") as! String
        desc = aDecoder.decodeObject(forKey: "desc") as! String
        fav = aDecoder.decodeBool(forKey: "fav")
        id = aDecoder.decodeObject(forKey: "id") as! String
        index = aDecoder.decodeInt32(forKey: "index")
        area = aDecoder.decodeObject(forKey: "area") as! String
        //print("init with coder called on \(name)")
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(url, forKey: "url")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(desc, forKey: "desc")
        aCoder.encode(fav, forKey: "fav")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(index, forKey: "index")
        aCoder.encode(area, forKey: "area")
        //print("Encode with coder called on \(name)")
    }
}
