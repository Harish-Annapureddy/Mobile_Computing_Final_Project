//
//  ResultsViewController.swift
//  IMDB Search
//
//  Created by Harish Kumar Annapureddy on 11/27/20.
//  Copyright © 2020 Harish Kumar Annapureddy. All rights reserved.
//

import UIKit
import SDWebImage

class ResultsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var items = [Search]()
    var _items = [Movie]()
    var isSimple = true
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSimple{
            return self._items.count
        }else{
            return self.items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSimple{
            let cell = tableView.dequeueReusableCell(withIdentifier: "simpleCell") as! SimpleTableViewCell
            cell.movieName.text = self._items[indexPath.row].name
            cell.year.text = self._items[indexPath.row].year
            cell.movieImage.image = UIImage(named: self._items[indexPath.row].imageName)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "IMDBCell")as! IMDBTableViewCell
            cell.movieName.text = self.items[indexPath.row].title
            cell.year.text = self.items[indexPath.row].year
            cell.IMDB.tag = indexPath.row
            cell.IMDB.addTarget(self, action: #selector(openInBrowser(sender:)), for: .touchUpInside)
            cell.movieImage.sd_setImage(with: URL(string: self.items[indexPath.row].poster ?? ""), completed: nil)
            return cell
        }
    }
    
    @objc func openInBrowser(sender: UIButton){
        if let url = URL(string: "https://www.imdb.com/title/"+(self.items[sender.tag].imdbID ?? "")){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.isSimple{
            if let url = URL(string: self._items[indexPath.row].link){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }

}
