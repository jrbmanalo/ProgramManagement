//
//  Project.swift
//  ProjectManagement
//
//  Created by Jan on 1/28/21.
//

import UIKit

struct Project {
	var title: String
	var desc: String
	var img: Data?
	var color: String?
	var date: Date
	
	init(title: String, desc: String, img: Data?, color: String?, date: Date) {
		self.title = title
		self.desc = desc
		self.img = img
		self.color = color
		self.date = date
	}
}
