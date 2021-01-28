//
//  EventSearchResultCell.swift
//  Eventex
//
//  Created by Wesley Osborne on 1/28/21.
//

import UIKit

class EventSearchResultCell: UITableViewCell {
  
  @IBOutlet var eventTitleLabel: UILabel!
  @IBOutlet var eventLocationLabel: UILabel!
//  @IBOutlet var eventDateLabel: UILabel!
  @IBOutlet var eventImage: UIImageView!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

}
