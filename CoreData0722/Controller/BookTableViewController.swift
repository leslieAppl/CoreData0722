//
//  BookTableViewController.swift
//  CoreData0722
//
//  Created by leslie on 7/22/20.
//  Copyright © 2020 leslie. All rights reserved.
//

import UIKit
import CoreData

class BookTableViewController: UITableViewController {
    
    //TODO: - 2 Accessing the context from a view controller
    var context: NSManagedObjectContext!
    var listOfBooks: [Books] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 100
        
        let app = UIApplication.shared
        let appDelegate = app.delegate as! AppDelegate
        context = appDelegate.context
    }
    
    //TODO: - 4 Fetching values from the Persistent Store
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ///1. To make a request, we first have to get the NSFetchRequest object by calling the fetchRequest() method on the subclass that corresponds to the objects we want to read (in this case we want to get books, so we call it on the Books class).
        ///IMPORTANT:
        ///The NSFetchRequest class is generic. We have studied how to create generic functions, but you can also create generic structures and classes. When a generic class is initialized, we have to specify the data type that the instance is going to use between angle brackets (NSFetchRequest<Books>). This is why you can also initialize generic arrays, sets and dictionaries with the data type between angle brackets (var myarray = Array<Int>()).
        let request: NSFetchRequest<Books> = Books.fetchRequest()
        
        //TODO: - 12 Predicate | Filtering
        /// Filtering books by year | Attribute Property
//        request.predicate = NSPredicate(format: "year = 1983", argumentArray: nil)
        
        /// Filtering books by author | Relationship Property
        ///Search for a value in a relationship with concatenating the properties with dot notation
        ///The name of the author was inserted inside the string using single quotes
//        request.predicate = NSPredicate(format: "author.name = 'leslie'", argumentArray: nil)
        
        /// Creating filters with placeholders
//        let search = "leslie"
//        request.predicate = NSPredicate(format: "author.name = %@", search)
        
        /// Creating filters with multiple values
//        let search = "leslie"
//        let year = 1983
//        request.predicate = NSPredicate(format: "author.name = %@ && year = %d", search, year)
        
        /// Filtering values with predicate keywords
//        let search = "leslie"
//        request.predicate = NSPredicate(format: "author.name BEGINSWITH[c] %@", search)
        
        //TODO: - 14 Sorting
        ///Sorting the books by title
//        let sort = NSSortDescriptor(key: "title", ascending: true)
//        request.sortDescriptors = [sort]
        
        ///Sorting books by author and year
//        let sort1 = NSSortDescriptor(key: "author.name", ascending: true)
//        let sort2 = NSSortDescriptor(key: "year", ascending: true)
//        request.sortDescriptors = [sort1, sort2]
        
        ///Sorting by title without differentiating between lowercase and uppercase letters
        let sort = NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        request.sortDescriptors = [sort]
        
        do {
            ///2. The next step is to fetch the objects with the context's fetch() method. This method returns an array of objects that we can assign to a property to be able to access the values from other methods in the class. In this example, we called that property listOfBooks.
            listOfBooks = try context.fetch(request)
        } catch {
            print("Error")
        }
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listOfBooks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "booksCell", for: indexPath) as! BooksCell
        
        let book = listOfBooks[indexPath.row]
        cell.bookTitle.text = book.title
//        cell.bookCover.image = book.thumbnail as? UIImage
        
        //TODO: - 9 Getting back the images from data
        if book.thumbnail != nil {
            cell.bookCover.image = UIImage(data: book.thumbnail as! Data)
        }

        cell.bookYear.text = String(book.year)
        
        let author = book.author
        if author != nil {
            cell.bookAuthor.text = author?.name
        } else {
            cell.bookAuthor.text = "no defined"
        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //TODO: - 15 Delete Object - Step 2:
        ///Delete the Books object from the Persistent Store when the user presses the Delete button
        if editingStyle == .delete {
            let book = listOfBooks[indexPath.row]
            context.delete(book)
            
            do {
                try context.save()  //Conformed deleting from core data model
                listOfBooks.remove(at: indexPath.row)   //removed from local constant
                tableView.deleteRows(at: [indexPath], with: .fade) //deleted from table view
                tableView.setEditing(false, animated: true)
            } catch {
                print("Error")
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func editBooks(_ sender: UIBarButtonItem) {
        //TODO: - 15 Delete Object - Step 1:
        ///To activate the table’s edition mode
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
        } else {
            tableView.setEditing(true, animated: true)
        }
    }
}
