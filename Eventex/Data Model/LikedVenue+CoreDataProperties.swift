//
//  LikedVenue+CoreDataProperties.swift
//  Eventex
//
//  Created by Wesley Osborne on 2/23/21.
//
//

import Foundation
import CoreData


extension LikedVenue {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LikedVenue> {
        return NSFetchRequest<LikedVenue>(entityName: "LikedVenue")
    }

    @NSManaged public var eventLocation: String
    @NSManaged public var event: LikedEvent

}

extension LikedVenue : Identifiable {

}
