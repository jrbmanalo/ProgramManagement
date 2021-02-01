//
//  ProjectsMainViewController.swift
//  ProjectManagement
//
//  Created by Jan on 1/28/21.
//

import UIKit

// MARK: - Create Project View Controller
class CreateProjectViewController: UIViewController, UINavigationControllerDelegate {

	static let identifier = "CreateProjectViewController"
	
	// MARK: Private IBOutlets
	@IBOutlet weak var colorsCollectionView: UICollectionView!
	@IBOutlet weak var uploadHeaderLabel: UILabel!
	@IBOutlet weak var projectImageView: UIImageView!
	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var descriptionTextView: UITextView!
	@IBOutlet weak var saveButton: UIButton!
	@IBOutlet weak var dateView: UIView!
	@IBOutlet weak var uploadHeaderImageButton: UIButton!
	@IBOutlet weak var dateTimeButton: UIButton!
	
	// MARK: - Private Constants
	private let projectMgmt = ProjectMgmt.shared
	private let datePicker = UIDatePicker()
	private var didAddDate = false
	
	// MARK: Public Variables
	var tapToDismissDatePicker = UITapGestureRecognizer()
	var datePickerBackground = UIView()
	var selectedProject: Project?
	var tapToDismissKeyboard = UITapGestureRecognizer()
	var colorPalette = ["Color1", "Color2", "Color3", "Color4", "Color5", "Color6"]
	var colorBG: String?
	var textViewDidChange = false
	var isCreating = true
	
	override func viewDidLoad() {
		super.viewDidLoad()
		titleTextField.delegate = self
		descriptionTextView.delegate = self
		setUI()
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	// MARK: - Private Functions
	private func setUI() {
		colorsCollectionView.isHidden = !isCreating
		titleTextField.borderStyle = isCreating ? .roundedRect : .none
		titleTextField.layer.borderColor = UIColor(named: "Project Card")?.cgColor
		titleTextField.isUserInteractionEnabled = isCreating
		descriptionTextView.backgroundColor = isCreating ? .white :  .clear
		descriptionTextView.isUserInteractionEnabled = isCreating
		descriptionTextView.textColor = isCreating ? .lightGray : .black
		descriptionTextView.text =  isCreating ? "Type Here" : ""
		descriptionTextView.backgroundColor = isCreating ? .white : .clear
		descriptionTextView.layer.cornerRadius = CGFloat(5.0)
		descriptionTextView.layer.borderWidth = isCreating ? 1 : 0
		descriptionTextView.layer.borderColor = UIColor(named: "Project Card")?.cgColor
		saveButton.isHidden = !isCreating
		uploadHeaderLabel.isHidden = !isCreating
		uploadHeaderImageButton.isHidden = !isCreating
		projectImageView.layer.cornerRadius = CGFloat(15.0)
		saveButton.layer.cornerRadius =  CGFloat(15.0)
		dateView.layer.cornerRadius = CGFloat(10.0)
		dateView.layer.borderWidth = 1
		dateView.layer.borderColor = UIColor(named: "Project Card")?.cgColor
		dateTimeButton.isUserInteractionEnabled = isCreating
		
		if let selectedProject = selectedProject {
			populateDetails(project: selectedProject)
		}
	}
	
	private func populateDetails(project: Project){
		titleTextField.text = project.title
		descriptionTextView.text = project.desc
		
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
		dateTimeButton.setTitle(dateString, for: .normal)
	}
	
	private func createAlert(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
		
		alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
			alert.dismiss(animated: true, completion: nil)
		}))
		
		self.present(alert, animated: true, completion: nil)
		
	}
	
	@objc private func keyboardWillShow(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
			if self.view.frame.origin.y == 0 && descriptionTextView.isFirstResponder {
				
				UIView.animate(withDuration: 0.5) { [weak self] in
					guard let self = self else { return }
					self.view.frame.origin.y -= keyboardSize.height
				}
			}
		}
	}

	@objc private func keyboardWillHide(notification: NSNotification) {
		animateFrameDown()
	}
	
	func animateFrameDown() {
		if self.view.frame.origin.y != 0 {
			UIView.animate(withDuration:  0.5) { [weak self] in
				guard let self = self else { return }
				self.view.frame.origin.y = 0
			}
		}
	}
	
	@objc private func datePickerDidChangeValue() {
		if datePicker.date >= Date() {
			didAddDate = true
			let formatter = DateFormatter()
			formatter.locale = .current
			formatter.dateFormat = "MMM dd, h:mm a"
			formatter.amSymbol = "am"
			formatter.pmSymbol = "pm"
			
			let dateString = formatter.string(from: datePicker.date)
			dateTimeButton.setTitle(dateString, for: .normal)
		} else {
			createAlert(title: "Invalid Date", message: "Please choose a future date")
		}
	}
	
	@IBAction func didTapBackButton() {
		navigationController?.popViewController(animated: true)
	}
	
	@IBAction func uploadHeaderImageButtonPressed() {
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		imagePicker.sourceType = .photoLibrary
		imagePicker.allowsEditing = true
		
		self.present(imagePicker, animated: true, completion: nil)
	}
	
	@IBAction func datePickerButtonPressed() {
		datePickerBackground.translatesAutoresizingMaskIntoConstraints = false
		datePickerBackground.backgroundColor = .black
		datePickerBackground.alpha = 0.60
		datePickerBackground.isUserInteractionEnabled = true
		view.addSubview(datePickerBackground)
		NSLayoutConstraint.activate([
			datePickerBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			datePickerBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			datePickerBackground.topAnchor.constraint(equalTo: view.topAnchor),
			datePickerBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor)
			
		])
		
		datePicker.translatesAutoresizingMaskIntoConstraints = false
		datePicker.preferredDatePickerStyle = .inline
		datePicker.datePickerMode = .dateAndTime
		datePicker.date = Date()
		datePicker.locale = .current
		datePicker.backgroundColor = .white
		datePicker.layer.cornerRadius = CGFloat(10.0)
		datePicker.layer.masksToBounds = true
		datePicker.addTarget(self, action: #selector(datePickerDidChangeValue), for: .valueChanged)
		view.addSubview(datePicker)
		NSLayoutConstraint.activate([
			datePicker.centerYAnchor.constraint(equalTo: datePickerBackground.centerYAnchor),
			datePicker.centerXAnchor.constraint(equalTo: datePickerBackground.centerXAnchor),
			datePicker.heightAnchor.constraint(equalToConstant: 360.0),
			datePicker.widthAnchor.constraint(equalToConstant: 360.0)
		])
		
		tapToDismissDatePicker = UITapGestureRecognizer(target: self,action: #selector(dismissDatePicker))
		tapToDismissDatePicker.cancelsTouchesInView = false
		tapToDismissDatePicker.delegate = self
		view.addGestureRecognizer(tapToDismissDatePicker)
	}
	
	@objc private func dismissDatePicker() {
		datePickerBackground.removeFromSuperview()
		datePicker.removeFromSuperview()
		view.removeGestureRecognizer(tapToDismissDatePicker)
	}
	
	@objc func dismissKeyboard() {
		self.view.endEditing(true)
	}
	
	@IBAction func saveButtonPressed() {
		var newProject: Project?
		var title: String?
		var desc: String?
		var img: UIImage?
		var color: String?
		
		
		if let hasTitle = titleTextField.text, !hasTitle.isEmpty {
			title = hasTitle
		} else {
			createAlert(title: "Missing Title", message: "Please enter a title.")
			return
		}
		
		if !didAddDate {
			createAlert(title: "Missing Date", message: "Please add a date.")
			return
		}
		
		if let hasDesc = descriptionTextView.text, !hasDesc.isEmpty, textViewDidChange {
			desc = hasDesc
		} else {
			createAlert(title: "Missing Description", message: "Please enter a description.")
			return
		}
		
		if let hasImg = projectImageView.image {
			img = hasImg
		} else if let hasColor = colorBG {
			color = hasColor
		} else {
			createAlert(title: "Missing Header", message: "Please select a header image or choose a color.")
			return
		}
		
		if let title = title, let desc = desc {
			if let img = img {
				let imgData = img.pngData()
				newProject = Project(title: title, desc: desc, img: imgData, color: nil, date: datePicker.date)
			} else if let color = color {
				newProject = Project(title: title, desc: desc, img: nil, color: color, date: datePicker.date)
			}
		}
		
		guard let project = newProject else { return }
		
		projectMgmt.save(project: project)
		createAlert(title: "Success", message: "New project is added.")
		
	}
}

