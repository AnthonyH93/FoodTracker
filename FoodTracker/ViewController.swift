//
//  ViewController.swift
//  FoodTracker
//
//  Created by Anthony Hopkins on 2020-07-03.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Handle the text field's user input through delegate callbacks.
        nameTextField.delegate = self
        //The self refers to the ViewController class because it's referenced inside the scope of the ViewController class definition.

    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        mealNameLabel.text = textField.text
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //Dismiss the picker if the user cancelled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        dismiss(animated: true, completion:nil)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        //Set image to photoImageView to display the selected image.
        photoImageView.image = image

        // print out the image size as a test
        print(image.size)
    }
    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UIButton) {
        //Hide the keyboard in case user taps while typing in the textbox.
        nameTextField.resignFirstResponder()
        
        let imagePicker = UIImagePickerController()
        //For a real device we could use .camera
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    @IBAction func setDefaultLabelText(_ sender: UIButton) {
        mealNameLabel.text = "Default Text"
    }
}

