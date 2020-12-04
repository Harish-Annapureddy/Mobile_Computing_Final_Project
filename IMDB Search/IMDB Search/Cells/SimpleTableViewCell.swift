//
//  SimpleTableViewCell.swift
//  IMDB Search
//
//  Created by Harish Kumar Annapureddy on 11/27/20.
//  Copyright © 2020 Harish Kumar Annapureddy. All rights reserved.
//

import UIKit

class SimpleTableViewCell: UITableViewCell {

    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
