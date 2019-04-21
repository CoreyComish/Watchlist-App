//
//  ViewController.swift
//  Watchlist
//
//  Created by Corey Comish on 4/20/19.
//  Copyright © 2019 Corey Comish. All rights reserved.
//

import UIKit
import TMDBSwift

class ViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    @IBOutlet weak var movieTitleTF: UITextField!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        TMDBConfig.apikey = "ac6045995596442d0ad6f068b91f0cee"
        movieTitleTF.delegate = self
        getMovie()
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        movieTitleLabel.text = textField.text
    }
    
    // MARK: Actions
    @IBAction func setDefaultLabelText(_ sender: UIButton) {
        movieTitleLabel.text = "Default Text"
    }
    
    func getMovie() {
        MovieMDB.movie(movieID: 7984, language: "en"){
            apiReturn, movie in
            if let movie = movie{
                print(movie.title)
                print(movie.revenue)
                print(movie.genres[0].name)
                print(movie.production_companies?[0].name)
                self.movieTitleLabel.text = movie.title!
            }
        }
    }
}
