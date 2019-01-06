//
//  wodViewController.swift
//  VCF
//
//  Created by Timothy Younkin on 1/5/19.
//  Copyright © 2019 Timothy Younkin. All rights reserved.
//

import UIKit
import os.log
extension UITextField {
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    // Default actions:
    @objc func doneButtonTapped() { self.resignFirstResponder() }
    @objc func cancelButtonTapped() { self.resignFirstResponder() }
}

class wodViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var scoreTextField: UITextField! {
        didSet { scoreTextField?.addDoneCancelToolbar() }
    }
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var wod: WOD?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameTextField.delegate = self
        
        // Set up views if editing an existing Meal.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy/MM/dd"
        if let wod = wod {
            navigationItem.title = wod.name
            nameTextField.text = wod.name
            scoreTextField.text = String(wod.score)
            datePicker.date = dateFormatter.date(from: wod.date!)!
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }

    //MARK: Navigation

    @IBAction func cancel(_ sender: Any) {
        let isPresentingInAddWodMode = presentingViewController is UITabBarController
        print("Cancel button is being pressed",isPresentingInAddWodMode,presentingViewController)
        if isPresentingInAddWodMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    // This method lets you configure a view controller before it's presented.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let score = (scoreTextField.text as! NSString).floatValue
//        let photo = photoImageView.image
//        let rating = ratingControl.rating
        let formatter = DateFormatter()
        formatter.dateFormat = "yy/MM/dd"
        let date = formatter.string(from: datePicker.date)
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        wod = WOD(name: name, date: date, score: score)
    }
    
    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }

}
