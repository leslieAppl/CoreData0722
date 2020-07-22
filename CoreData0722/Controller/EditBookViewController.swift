//
//  EditBookViewController.swift
//  CoreData0722
//
//  Created by leslie on 7/22/20.
//  Copyright © 2020 leslie. All rights reserved.
//

import UIKit
import CoreData

//TODO: - 3 Adding new objects to the Persistent Store
class EditBookViewController: UIViewController {

    @IBOutlet weak var bookTitle: UITextField!
    @IBOutlet weak var bookYear: UITextField!
    
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bookTitle.becomeFirstResponder()
        let app = UIApplication.shared
        let appDelegate = app.delegate as! AppDelegate
        context = appDelegate.context
    }
    
    @IBAction func saveBookBtnPressed(_ sender: UIBarButtonItem) {
        let year = Int32(bookYear.text!)
        let title = bookTitle.text!.trimmingCharacters(in: .whitespaces)
        
        if title != "" && year != nil {
            let newBook = Books(context: context)
            newBook.title = title
            newBook.year = year!
            newBook.cover = UIImage(named: "nocover")
            newBook.thumbnail = UIImage(named: "nothumbnail")
            newBook.author = nil
            
            do {
                try context.save()
            } catch {
                print("Error")
            }
            
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
