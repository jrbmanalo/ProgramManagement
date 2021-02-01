//
//  ProjectCell.swift
//  ProjectManagement
//
//  Created by Jan on 1/29/21.
//

import UIKit

class ProjectCell: UITableViewCell {

	@IBOutlet weak var projectImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var projectCard: UIView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		projectCard.layer.cornerRadius = CGFloat(10.0)
		projectCard.layer.borderWidth = 1
		projectCard.layer.borderColor = UIColor(named: "Project Card")?.cgColor
		projectImageView.layer.cornerRadius = CGFloat(10.0)
    }
	
	func configure(project: Project) {
		titleLabel.text = project.title
		
		if let imgData = project.img {
			let img = UIImage(data: imgData)
			projectImageView.image = img
		} else if let color = project.color {
			projectImageView.backgroundColor = UIColor(named: color)
		}
		
		let formatter = DateFormatter()
		formatter.locale = .current
		formatter.dateFormat = "MMM dd, h:mm a"
		formatter.amSymbol = "am"
		formatter.pmSymbol = "pm"
		
		let dateString = formatter.string(from: project.date)
		dateLabel.text = dateString
	}
	
	func clear() {
		projectImageView.image = nil
		projectImageView.backgroundColor = .white
		dateLabel.text = ""
		titleLabel.text = ""
	}
	
	override func prepareForReuse() {
		clear()
	}

}
