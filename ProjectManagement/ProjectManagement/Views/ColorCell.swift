//
//  ColorCell.swift
//  ProjectManagement
//
//  Created by Jan on 1/30/21.
//

import UIKit

class ColorCell: UICollectionViewCell {
	
	@IBOutlet weak var BGImageView: UIImageView!
	@IBOutlet weak var innerImageView: UIImageView!
	static let identifier = "ColorCell"

	override func layoutSubviews() {
		setUI()
	}
	
	func configure(color: String){
		BGImageView.backgroundColor = UIColor(named: color)
	}
	
	private func setUI() {
		BGImageView.layer.cornerRadius = BGImageView.frame.width/2
	}
	
	private func setButtonSelected(){
		innerImageView.image = UIImage(systemName: "checkmark")
		BGImageView.image = UIImage(named: "Ellipse")
	}
	
	func clear() {
		innerImageView.image = nil
		BGImageView.image = nil
	}
	
	override func prepareForReuse() {
		clear()
	}
	
	private var _isSelected: Bool = false
	override var isSelected: Bool {
		set {
			_isSelected = newValue
			
			if _isSelected {
				setButtonSelected()
			} else {
				clear()
			}
		}
		get {
			return _isSelected
		}
	}

}
