//
//  LikedEvent+CoreDataProperties.swift
//  Eventex
//
//  Created by Wesley Osborne on 2/12/21.
//
//

import Foundation
import CoreData


extension LikedEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LikedEvent> {
        return NSFetchRequest<LikedEvent>(entityName: "LikedEvent")
    }

    @NSManaged public var eventTitle: String
    @NSManaged public var dateTime: String
    @NSManaged public var id: Int64
    @NSManaged public var performers: NSSet
    @NSManaged public var venue: LikedVenue

}

// MARK: Generated accessors for performers
extension LikedEvent {

    @objc(addPerformersObject:)
    @NSManaged public func addToPerformers(_ value: LikedPerformer)

    @objc(removePerformersObject:)
    @NSManaged public func removeFromPerformers(_ value: LikedPerformer)

    @objc(addPerformers:)
    @NSManaged public func addToPerformers(_ values: NSSet)

    @objc(removePerformers:)
    @NSManaged public func removeFromPerformers(_ values: NSSet)

}

extension LikedEvent : Identifiable {

}
