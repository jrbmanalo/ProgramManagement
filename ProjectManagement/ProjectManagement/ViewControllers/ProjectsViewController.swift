//
//  ProjectsTableViewController.swift
//  ProjectManagement
//
//  Created by Jan on 1/31/21.
//

import UIKit

// MARK: - Projects View Controller
class ProjectsViewController: UIViewController {

	// MARK: Private IBOutlets
	@IBOutlet weak var projectsTable: UITableView!
	
	// MARK: - Private Constants
	private let projectMgmt = ProjectMgmt.shared
	private var projects = [Project]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		navigationController?.navigationBar.isHidden = true
    }
	
	override func viewWillAppear(_ animated: Bool) {
		do {
			projects = try projectMgmt.fetchProject()
			projectsTable.reloadData()
		} catch {
			print(error)
		}
	}
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension ProjectsViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return projects.count + 1
	}

 
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let row = indexPath.row

		if row == projects.count {
			let createProjectCell = tableView.dequeueReusableCell(withIdentifier: "CreateProjectCell", for: indexPath) as! CreateProjectCell
			return createProjectCell
		} else {
			let existingProjectCell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as! ProjectCell
			existingProjectCell.configure(project: projects[row])
			return existingProjectCell
		}
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 193.0
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
		let createVC = sb.instantiateViewController(identifier: CreateProjectViewController.identifier) as! CreateProjectViewController
		createVC.isCreating = indexPath.row == projects.count
		if indexPath.row != projects.count {
			createVC.selectedProject = projects[indexPath.row]
		}

		navigationController?.pushViewController(createVC, animated: true)
	}
}
