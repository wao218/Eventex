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
  @IBOutlet var eventDateLabel: UILabel!
  @IBOutlet var eventImage: UIImageView!

  override func awakeFromNib() {
    super.awakeFromNib()
    let selectedView = UIView(frame: CGRect.zero)
    selectedView.backgroundColor = UIColor(named: "SelectionColor")?.withAlphaComponent(0.5)
    selectedBackgroundView = selectedView
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

}
