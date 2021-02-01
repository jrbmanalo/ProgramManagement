//
//  CreateProjectViewController+Extensions.swift
//  ProjectManagement
//
//  Created by Jan on 1/31/21.
//

import UIKit

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension CreateProjectViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return colorPalette.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath) as! ColorCell
		cell.configure(color: colorPalette[indexPath.row])
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 40, height: 40)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		projectImageView.image = nil
		projectImageView.backgroundColor = UIColor(named: colorPalette[indexPath.row])
		colorBG = colorPalette[indexPath.row]
	}
	
	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath) as! ColorCell
		cell.clear()
	}
}

// MARK: - UIImagePickerControllerDelegate
extension CreateProjectViewController: UIImagePickerControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.editedImage] as? UIImage else {
			return
		}
		
		self.projectImageView.image = image
		self.dismiss(animated: true, completion: nil)
	}
	
}

// MARK: - UITextFieldDelegate
extension CreateProjectViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		animateFrameDown()
	}
}

// MARK: - UITextViewDelegate
extension CreateProjectViewController: UITextViewDelegate {
	func textViewDidBeginEditing(_ textView: UITextView) {
		if !textViewDidChange {
			descriptionTextView.text = ""
			descriptionTextView.textColor = .black
			tapToDismissKeyboard = UITapGestureRecognizer(target: self,action: #selector(dismissKeyboard))
			tapToDismissKeyboard.cancelsTouchesInView = false
			tapToDismissKeyboard.delegate = self
			view.addGestureRecognizer(tapToDismissKeyboard)
		}
		
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		guard let _ = textView.text else { return }
		
		textViewDidChange = true
	}
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		let numLines = Int(textView.contentSize.height / textView.font!.lineHeight)

		if numLines >= 10 {
			return false
		}
		return true
	}
}

// MARK: - UIGestureRecognizerDelegate
extension CreateProjectViewController: UIGestureRecognizerDelegate {
	
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		return (touch.view === datePickerBackground || touch.view === self.view)
	}
}
