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
    
    var context: NSManagedObjectContext!
    var fetchedController: NSFetchedResultsController<Books>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 100
        
        let app = UIApplication.shared
        let appDelegate = app.delegate as! AppDelegate
        context = appDelegate.context
        
        //TODO: - 1 Fetching objects with an NSFetchedResultsController object
//        let request: NSFetchRequest<Books> = Books.fetchRequest()
//        let sort = NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
//        request.sortDescriptors = [sort]
//
//        fetchedController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//        fetchedController.delegate = self
//
//        do {
//            try fetchedController.performFetch()
//        } catch {
//            print("Error")
//        }
        
        //TODO: - 2 Organizing the Books objects in sections
        let request: NSFetchRequest<Books> = Books.fetchRequest()
        let sort1 = NSSortDescriptor(key: "author.name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        let sort2 = NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        request.sortDescriptors = [sort1, sort2]
        
        fetchedController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "author.name", cacheName: nil)
        fetchedController.delegate = self
        
        do {
            try fetchedController.performFetch()
        } catch {
            print("Error")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //TODO: - 4 Updating 'fetchedController' after adding books or author returning back to this viewController.
        let request: NSFetchRequest<Books> = Books.fetchRequest()
        let sort1 = NSSortDescriptor(key: "author.name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        let sort2 = NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        request.sortDescriptors = [sort1, sort2]

        fetchedController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "author.name", cacheName: nil)
        
//        fetchedController.delegate = self (do not use second delegate instance)

        do {
            try fetchedController.performFetch()
        } catch {
            print("Error")
        }
        
        tableView.reloadData()  //Updating data..
    }

    // MARK: - Table view data source
    //TODO: - 3 Implementing the necessary protocol methods to work with sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedController.sections {
            return sections.count
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = fetchedController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects  //numberOfRowsInSection
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.name
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "booksCell", for: indexPath) as! BooksCell
        
        updateCell(cell: cell, path: indexPath)
        
        return cell
    }
    
    func updateCell(cell: BooksCell, path: IndexPath) {
        let book = fetchedController.object(at: path)
        
        cell.bookTitle.text = book.title
        
        if book.thumbnail != nil {
            cell.bookCover.image = UIImage(data: book.thumbnail!)
        }
        
        let year = book.year
        cell.bookYear.text = "Year: \(year)"
        
        let authorName = book.author?.name
        if authorName != nil {
            cell.bookAuthor.text = authorName
        }
        else {
            cell.bookAuthor.text = "Not Defined"
        }
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
            
        if editingStyle == .delete {
            let book = fetchedController.object(at: indexPath)
            context.delete(book)
            
            do {
                try context.save()
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

//MARK: - NSFetchedResultsControllerDelegate Protocol
extension BookTableViewController: NSFetchedResultsControllerDelegate {
    
    ///2 Organizing the Books objects in sections
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            let index = IndexSet(integer: sectionIndex)
            tableView.insertSections(index, with: .fade)
        case .delete:
            let index = IndexSet(integer: sectionIndex)
            tableView.deleteSections(index, with: .fade)
        default:
            break
        }
        tableView.reloadData()
    }
    
    ///1 Fetching objects with an NSFetchedResultsController object
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let path = indexPath {
                tableView.deleteRows(at: [path], with: .fade)
            }
        case .insert:
            if let path = newIndexPath {
                tableView.insertRows(at: [path], with: .fade)
            }
        case .update:
            if let path = indexPath {
                let cell = tableView.cellForRow(at: path) as! BooksCell
                updateCell(cell: cell, path: path)
            }
        default:
            break
        }
    }
}
