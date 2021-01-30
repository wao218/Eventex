//
//  Event.swift
//  Eventex
//
//  Created by Wesley Osborne on 1/29/21.
//

import Foundation

struct Event: Codable {
  var eventTitle: String
  var venue: Venue
  var dateTime: String
  var performers: [Performers]
  
  enum CodingKeys: String, CodingKey {
    case eventTitle = "short_title"
    case venue
    case performers
    case dateTime = "datetime_utc"
  }
  
}
