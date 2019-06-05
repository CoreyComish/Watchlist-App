//
//  ViewController.swift
//  Watchlist
//
//  Created by Corey Comish on 4/20/19.
//  Copyright © 2019 Corey Comish. All rights reserved.
//

import UIKit
import TMDBSwift
import os.log

class ViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    @IBOutlet weak var movieTitleTF: UITextField!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var ratingControl: RatingControl!
    
    var movie : Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        TMDBConfig.apikey = "ac6045995596442d0ad6f068b91f0cee"
        movieTitleTF.delegate = self
        if let movie = movie {
            navigationItem.title = movie.name
            movieTitleTF.text = movie.name
            movieImage.image = movie.photo
        }
        updateSaveButtonState()
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
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
    
    // MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddMovieMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMovieMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The ViewController is not inside a navigation controller.")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = movieTitleTF.text ?? ""
        let photo = movieImage.image
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        movie = Movie(name: name, photo: photo, rating: rating)
    }
    
    // MARK: Actions
    @IBAction func setDefaultLabelText(_ sender: UIButton) {
        SearchMDB.movie(query: movieTitleTF.text!, language: "en", page: 1, includeAdult: true, year: 0, primaryReleaseYear: 0){
            data, wrds in
            let search = wrds?[0].id;
            self.setImage(id: search!);
        }
    }
    
    func setImage(id: Int) {
        MovieMDB.images(movieID: id, language: "en") {
            data, imgs in
            if let images = imgs{
                let imgUrl = images.posters[0].file_path!;
                let urlString = "http://image.tmdb.org/t/p/w500" + imgUrl;
                guard let url = URL(string: urlString) else { return }
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        print("Failed fetching image:", error!)
                        return
                    }
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        print("Not a proper HTTPURLResponse or statusCode")
                        return
                    }
                    DispatchQueue.main.async {
                        self.movieImage.image = UIImage(data: data!)
                    }
                    }.resume()
            }
        }
    }
    
    // MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = movieTitleTF.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
}
