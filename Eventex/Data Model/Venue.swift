//
//  Venue.swift
//  Eventex
//
//  Created by Wesley Osborne on 1/29/21.
//

import Foundation

struct Venue: Codable {
  var eventLocation: String
  
  enum CodingKeys: String, CodingKey {
    case eventLocation = "display_location"
  }
}
