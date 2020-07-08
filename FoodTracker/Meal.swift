//
//  Meal.swift
//  FoodTracker
//
//  Created by Anthony Hopkins on 2020-07-07.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import UIKit

class Meal {
    
    //MARK: Initialization
    
    //Prepares and instance of a class for use
    init?(name: String, photo: UIImage?, rating: Int) {
        
        //Initialization should fail if there is no name or a negative rating
        if (name.isEmpty || rating < 0 || rating > 5) {
            return nil
        }
        
        //Initialize stored properties.
        self.name = name
        self.photo = photo
        self.rating = rating
        
    }
    
    //MARK: Properties
    
    var name: String
    //? means it is optional as not all meals will have a photo
    var photo: UIImage?
    var rating: Int
}
