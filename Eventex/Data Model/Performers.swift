//
//  Performers.swift
//  Eventex
//
//  Created by Wesley Osborne on 1/29/21.
//

import Foundation

struct Performers: Codable {
  var imageURL: String
  
  enum CodingKeys: String, CodingKey {
    case imageURL = "image"
  }
}
