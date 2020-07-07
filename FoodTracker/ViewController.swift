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
    @IBOutlet weak var ratingControl: RatingControl!
    
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
                    height = dimension.height / aspectRatio
                } else {                                        // Portrait image
                    height = dimension.height
                    width = dimension.width * aspectRatio
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
