//
//  ContactBirthdayCell.swift
//  BirthdayFinder
//  Created by Hari Patel on 4/29/22.
//

import UIKit

class ContactBirthdayCell: UITableViewCell {
  
  @IBOutlet weak var lblFullname: UILabel!
  @IBOutlet weak var lblBirthday: UILabel!
  @IBOutlet weak var imgContactImage: UIImageView!
  @IBOutlet weak var lblEmail: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    imgContactImage.layer.cornerRadius = 25.0
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
