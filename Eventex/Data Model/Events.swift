//
//  Events.swift
//  Eventex
//
//  Created by Wesley Osborne on 1/29/21.
//

import Foundation

struct Events: Codable {
  var events: [Event]
}

struct Event: Codable {
  var eventTitle: String
  var venue: Venue
  var dateTime: String
  var performers: [Performers]
  var id: Int
  var url: String
  
  enum CodingKeys: String, CodingKey {
    case eventTitle = "short_title"
    case venue
    case performers
    case dateTime = "datetime_utc"
    case id
    case url
  }
  
}

struct Venue: Codable {
  var eventLocation: String
  
  enum CodingKeys: String, CodingKey {
    case eventLocation = "display_location"
  }
}

struct Performers: Codable {
  var imageURL: String
  
  enum CodingKeys: String, CodingKey {
    case imageURL = "image"
  }
}
