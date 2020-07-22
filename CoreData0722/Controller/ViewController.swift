//
//  ViewController.swift
//  CoreData0722
//
//  Created by leslie on 7/22/20.
//  Copyright © 2020 leslie. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    //TODO: - 2 Accessing the context from a view controller
    var context: NSManagedObjectContext!
    var listOfBooks: [Books] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let app = UIApplication.shared
        let appDelegate = app.delegate as! AppDelegate
        context = appDelegate.context
        
    }


}

