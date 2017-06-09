//
//  ParkData.swift
//  ParkFinder
//
//  Created by Jacob Westerback (RIT Student) on 3/31/17.
//  Copyright © 2017 Jacob Westerback (RIT Student). All rights reserved.
//

import Foundation
import UIKit

public class ParkData {
    
    // MARK: - Initialization
    
    private init () {
    }
    public static let sharedData = ParkData()
    
    // MARK: - Data
    private var parks = [StatePark]()
    
    // returns all parks that are favorited in the order of their favIndex
    private var favorites:[StatePark] {
        var favParks = [StatePark]()
        for p in parks {
            if (p.isFavorite) {
                favParks.append(p)
            }
        }
        favParks.sort(by:{$1.favIndex > $0.favIndex})
        return favParks
    }
    
    // MARK: - Parks Helper Functions
    
    // returns all parks in alphabetical order
    public var allParks:[StatePark] {
        sortParks()
        return parks
    }
    public func setParks(newParks:[StatePark]) {
        //print("Set Parks")
        parks = newParks;
        sortParks()
    }
    private func sortParks() {
        parks.sort(by:{$1.parkName > $0.parkName})
    }
    
    // MARK: - Favorites Helper Functions
    
    public var allFavs:[StatePark] {
        return favorites
    }
    
    // Swaps two parks and re cxalcualtes their indexies
    public func swapFav(from:Int, to:Int) {
        var tempFavs = allFavs
        let parkToMove = tempFavs.remove(at: from)
        tempFavs.insert(parkToMove, at: to)
        
        for p in 0..<tempFavs.count {
            tempFavs[p].index = Int32(p)
        }
        
        NotificationCenter.default.post(name: favoritesChangedNotification, object: self, userInfo:[:])
    }
    
    // Toggles weather or not a park is favorited
    public func toggleFavorite(park:StatePark) {
        park.toggleFavorite()
        if park.isFavorite {
            park.index = Int32(allFavs.count) - 1
        } else {
            park.index = 0
        }
        NotificationCenter.default.post(name: favoritesChangedNotification, object: self, userInfo:[:])
    }
    
    // Removes a park from the favorites list
    public func deleteFav(index: IndexPath) {
        let toRemove = ParkData.sharedData.allFavs[index.row]
        if(toRemove.isFavorite) {
            toRemove.toggleFavorite()
            toRemove.index = 0
        
            NotificationCenter.default.post(name: favoritesChangedNotification, object: self, userInfo:[:])
        }
    }
}
