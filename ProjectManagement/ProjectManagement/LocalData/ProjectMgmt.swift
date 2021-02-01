//
//  ProjectMgmt.swift
//  ProjectManagement
//
//  Created by Jan on 1/28/21.
//

import UIKit
import CoreData

// MARK: - Project Management
class ProjectMgmt {
	
	// MARK: - Static Constants
	static let entity = "Project"
	static let shared = ProjectMgmt()
	
	// MARK: - Private Constants
	private let persistentContainer = NSPersistentContainer(name: "ProjectManagement")
	private let appDelegate = UIApplication.shared.delegate
	
	private init() {}

	
	// MARK: - Public Functions
	
	/// Save a new project to Core Data
	/// - Parameter
	/// - project:  Project
	func save(project: Project) {
		guard let appDelegate = appDelegate as? AppDelegate else { return }
		
		let managedContext = appDelegate.persistentContainer.viewContext
		let entity = NSEntityDescription.entity(forEntityName: ProjectMgmt.entity, in: managedContext)!
		let newProject = NSManagedObject(entity: entity,insertInto: managedContext)
	
		newProject.setValue(project.title, forKeyPath: "title")
		newProject.setValue(project.date, forKeyPath: "date")
		newProject.setValue(project.desc, forKeyPath: "desc")
		newProject.setValue(project.img, forKeyPath: "image")
		newProject.setValue(project.color, forKeyPath: "color")
		print(newProject)
		do {
			try managedContext.save()
		} catch let error as NSError {
			print("Could not save. \(error), \(error.userInfo)")
		}
	}
	
	
	
	/// Fetch existing projects from Core Data
	/// - Returns: Array of Project
	func fetchProject() throws -> [Project] {
		guard let appDelegate = appDelegate as? AppDelegate else { return []}
		
		let managedContext = appDelegate.persistentContainer.viewContext
		let request =  NSFetchRequest<NSFetchRequestResult>(entityName: ProjectMgmt.entity)
		
		do {
			var currentProjects = [Project]()
			let result = try managedContext.fetch(request)
			
			for data in result as! [NSManagedObject] {
				
				let title = data.value(forKey: "title") as! String
				let desc = data.value(forKey: "desc") as! String
				let date = data.value(forKey: "date") as! Date
				let imgdata = data.value(forKey: "image") as? Data
				let color = data.value(forKey: "color") as? String
				
				currentProjects.append(Project(title: title, desc: desc, img: imgdata, color: color, date: date))
			}
			return currentProjects
		} catch {
			print("Could not fetch: \(error)")
		}
		
		return []
	}
	
	
}
