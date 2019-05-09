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
    var photo: UIImage;
    
    // MARK: Init
    
    init?(name:String, photo: UIImage)
    {
        if (name.isEmpty)
        {
            return nil
        }
        
        self.name = name;
        self.photo = photo;
    }
}

