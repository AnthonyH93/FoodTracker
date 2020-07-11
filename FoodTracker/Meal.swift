//
//  Meal.swift
//  FoodTracker
//
//  Created by Anthony Hopkins on 2020-07-07.
//  Copyright © 2020 Anthony Hopkins. All rights reserved.
//

import UIKit
import os.log

class Meal : NSObject, NSCoding {
    
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
    
    //MARK: Archiving Paths
    
    //Marked with static since they belong to the class instead of an instance of the class
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
    
    //convenience means it is a secondary initializer (must call designated initializer), the ? means it is failable
    required convenience init?(coder aDecoder: NSCoder) {
        //The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        //Because photo is an optional property of Meal, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        //Must call designated initializer.
        self.init(name: name, photo: photo, rating: rating)
    }
}
