//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Anthony Hopkins on 2020-07-03.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new meal.
     */
    var meal: Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Handle the text field's user input through delegate callbacks.
        nameTextField.delegate = self
        //The self refers to the ViewController class because it's referenced inside the scope of the ViewController class definition.
        
        //Setup views if editing an existing meal
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        
        //Enable the save button only if the text field has a valid Meal name.
        updateSaveButtonState()

    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Disable the save button while editing
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let targetSize = photoImageView.image?.size else { return }
        
        dismiss(animated: true, completion:nil)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        let newImage = image.resizeImage(targetSize, opaque: true)
        
        //Set image to photoImageView to display the selected image.
        photoImageView.image = newImage

        // print out the image size as a test
        print(newImage.size)
    }
    
    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        //Depending on style of presentation (modal or push presentation), thi view controller needs to be dismissed in two different ways.
        let isPresentingAddMealMode = presentingViewController is UINavigationController
        if isPresentingAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MEalViewController is not inside a navigation controller.")
        }
    }
    
    //This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Good habit to call this when we override the prepare(for:sender)
        super.prepare(for: segue, sender: sender)
        
        //Configure the destination view controller only when the save button is pressed.
        //The .debug type means it only outputs when debugging, not in a shipped app environment
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        //the ?? "" singals a default value in the case that name is nil
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        var rating = ratingControl.rating
        
        //Issue where rating is 10 higher than it should be
        if (rating > 10){
            rating-=10
        }
        //Set the meal to be passed to MealTableViewController after the unwind segue.
        meal = Meal(name: name, photo: photo, rating: rating)
    }
    
    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UIButton) {
        //Hide the keyboard in case user taps while typing in the textbox.
        nameTextField.resignFirstResponder()
        
        let imagePicker = UIImagePickerController()
        
        //For simulator we have to use the photo library, but for real device allow camera to be used
        #if targetEnvironment(simulator)
        imagePicker.sourceType = .photoLibrary
        #else
        imagePicker.sourceType = .camera
        #endif
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    //MARK: Private Methods

    private func updateSaveButtonState() {
        //Disable the save button if the text field is empty
        let text = nameTextField.text ?? ""
        if (text.isEmpty){
            saveButton.isEnabled = false
        }
        else {
            saveButton.isEnabled = true
        }
    }
}

//Function to scale the images to force them to fit into the image view
extension UIImage {
    func resizeImage(_ dimension: CGSize, opaque: Bool, contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImage {
        var width =  dimension.width
        var height = dimension.height
        var newImage: UIImage

        let size = self.size
        let aspectRatio =  size.width/size.height

        switch contentMode {
            case .scaleAspectFit:
                if aspectRatio > 1 {                            // Landscape image
                    width = dimension.width
                    height = 275.0
                } else {                                        // Portrait image
                    height = dimension.height
                    width = 400.0
                }

        default:
            fatalError("UIIMage.resizeToFit(): FATAL: Unimplemented ContentMode")
        }

        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = opaque
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
            newImage = renderer.image {
                (context) in
                self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), opaque, 0)
                self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
                newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }

        return newImage
    }
}
