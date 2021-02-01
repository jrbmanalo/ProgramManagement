//
//  CreateProjectCell.swift
//  ProjectManagement
//
//  Created by Jan on 1/29/21.
//

import UIKit

class CreateProjectCell: UITableViewCell {

	@IBOutlet weak var projectCard: UIView!
	
	override func awakeFromNib() {
        super.awakeFromNib()		
		projectCard.layer.cornerRadius = 10
		projectCard.layer.borderWidth = 1
		projectCard.layer.borderColor = UIColor(named: "Project Card")?.cgColor
    }
	
}
