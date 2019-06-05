//
//  Movie.swift
//  Watchlist
//
//  Created by Corey Comish on 5/8/19.
//  Copyright © 2019 Corey Comish. All rights reserved.
//

import UIKit

class Movie {
    
    // MARK: Properties
    
    var name: String
    var photo: UIImage?
    var rating: Int
    
    // MARK: Init
    
    init?(name:String, photo: UIImage? = nil, rating: Int)
    {
        if (name.isEmpty || rating < 0)
        {
            return nil
        }
        
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        self.name = name;
        self.photo = photo;
        self.rating = rating;
    }
}

