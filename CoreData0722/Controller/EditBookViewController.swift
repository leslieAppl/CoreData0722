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
    @IBOutlet weak var authorName: UILabel!
    
    var context: NSManagedObjectContext!
    var selectedAuthor: Authors!
    
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
//            newBook.cover = UIImage(named: "nocover")
//            newBook.thumbnail = UIImage(named: "nothumbnail")
            
            //TODO: - 8 Converting images into raw data
            ///Presetting: books.xcdatamodeld -> Books Entity -> cover and thumbnail Attributes ->
            ///Attribute Type: Binary Data; Deprecated: Store in External Record File.
            let nocover = UIImage(named: "nocover")
            let nothumbnail = UIImage(named: "nothumbnail")
            newBook.cover = nocover?.pngData()
            newBook.thumbnail = nothumbnail?.pngData()            
            newBook.author = selectedAuthor
            
            do {
                try context.save()
            } catch {
                print("Error")
            }
            
            navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    //TODO: - 5 Adding an author to the book
    @IBAction func backAuthor(_ segue: UIStoryboardSegue) {
        if segue.identifier == "backFromList" {
            let controller = segue.source as! AuthorsTableViewController
            selectedAuthor = controller.selectedAuthor
            authorName.text = selectedAuthor.name
        }
        else if segue.identifier == "backFromNew" {
            let controller = segue.source as! EditAuthorViewController
            selectedAuthor = controller.selectedAuthor
            authorName.text = selectedAuthor.name
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
