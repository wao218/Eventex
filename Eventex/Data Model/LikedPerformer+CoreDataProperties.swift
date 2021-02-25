//
//  LikedPerformer+CoreDataProperties.swift
//  Eventex
//
//  Created by Wesley Osborne on 2/23/21.
//
//

import Foundation
import CoreData


extension LikedPerformer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LikedPerformer> {
        return NSFetchRequest<LikedPerformer>(entityName: "LikedPerformer")
    }

    @NSManaged public var imageURL: String
    @NSManaged public var event: LikedEvent

}

extension LikedPerformer : Identifiable {

}
