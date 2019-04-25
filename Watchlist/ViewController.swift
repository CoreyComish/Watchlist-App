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
    @IBOutlet weak var movieImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        TMDBConfig.apikey = "ac6045995596442d0ad6f068b91f0cee"
        movieTitleTF.delegate = self
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
        movieTitleLabel.text = movieTitleTF.text;
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
    
}
