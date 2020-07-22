//
//  BooksCell.swift
//  CoreData0722
//
//  Created by leslie on 7/22/20.
//  Copyright © 2020 leslie. All rights reserved.
//

import UIKit

class BooksCell: UITableViewCell {

    @IBOutlet weak var bookCover: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var bookYear: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
