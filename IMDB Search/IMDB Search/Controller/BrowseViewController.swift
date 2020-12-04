//
//  BrowseViewController.swift
//  IMDB Search
//
//  Created by Harish Kumar Annapureddy on 11/27/20.
//  Copyright © 2020 Harish Kumar Annapureddy. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var contentYear: UITextField!
    @IBOutlet weak var contentGenre: UITextField!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    private var pickerView = UIPickerView()
    private var year = ["2019", "2020"]
    private var genre = [String]()
    private var pickerData = [String]()
    private var currentTextField: UITextField!
    
    private var movies = [Movie]()
    private var allMovies = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getData()
        loader.isHidden = true
        loader.hidesWhenStopped = true
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.contentYear.delegate = self
        self.contentGenre.delegate = self
        self.pickerView.reloadAllComponents()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ResultsViewController
        vc.isSimple = true
        vc._items = self.movies
    }
    
    func getData(){
        if let path = Bundle.main.path(forResource: "Titles", ofType: "json") {
            do{
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let movies = jsonResult as? [[String: String]]{
                    for i in movies{
                        self.allMovies.append(Movie(data: i))
                    }
                }
            } catch {
                self.showAlert(title: "Error", message: error.localizedDescription) { (_) in }
            }
        }
        if let path = Bundle.main.path(forResource: "genre", ofType: "json") {
            do{
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let genre = jsonResult as? [[String: String]]{
                    for i in genre{
                        self.genre.append(i["moviegenre"] ?? "")
                    }
                    self.pickerView.reloadAllComponents()
                }
            } catch {
                self.showAlert(title: "Error", message: error.localizedDescription) { (_) in }
            }
        }
    }
    
    @IBAction func search(_ sender: Any) {
        if let year = self.contentYear.text, let genre = self.contentGenre.text{
            if year != "" && genre != ""{
                self.movies = self.allMovies.filter({$0.genre == genre && $0.year == year})
                self.performSegue(withIdentifier: "results", sender: nil)
            }else if year != ""{
                self.movies = self.allMovies.filter({$0.year == year})
                self.performSegue(withIdentifier: "results", sender: nil)
            }else if genre != ""{
                self.movies = self.allMovies.filter({$0.genre == genre})
                self.performSegue(withIdentifier: "results", sender: nil)
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.currentTextField = textField
        if self.contentYear == textField{
            self.pickerData = self.year
            self.pickerView.reloadAllComponents()
            self.pickerView.selectRow(0, inComponent: 0, animated: true)
            self.contentYear.inputView = pickerView
        }else if self.contentGenre == textField{
            self.pickerData = self.genre
            self.pickerView.reloadAllComponents()
            self.pickerView.selectRow(0, inComponent: 0, animated: true)
            self.contentGenre.inputView = pickerView
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func showAlert(title: String, message: String, completion: @escaping (_ done: String?) -> ()){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_) in
            completion(nil)
        }))
        self.present(alert, animated: true)
    }

}

extension BrowseViewController{
    
    //code for the picker view
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currentTextField.text = self.pickerData[row]
    }
    
}
