//
//  BookTableViewController.swift
//  CoreData0722
//
//  Created by leslie on 7/22/20.
//  Copyright © 2020 leslie. All rights reserved.
//

import UIKit
import CoreData

//MARK: - Fetching objects with an NSFetchedResultsController object
class BookTableViewController: UITableViewController {
    
    var context: NSManagedObjectContext!
    var fetchedController: NSFetchedResultsController<Books>!
    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 100
        
        let app = UIApplication.shared
        let appDelegate = app.delegate as! AppDelegate
        context = appDelegate.context
        
        //MARK: - Searching books
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController

        let request: NSFetchRequest<Books> = Books.fetchRequest()
        let sort = NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        request.sortDescriptors = [sort]

        fetchedController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedController.delegate = self

        do {
            try fetchedController.performFetch()
        } catch {
            print("Error")
        }
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = fetchedController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects  //numberOfRowsInSection
        }
        return 0
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

    //MARK: - Deleting a book
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

    //MARK: - To activate the table’s edition mode
    @IBAction func editBooks(_ sender: UIBarButtonItem) {
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
    
    //MARK: - Updating the table
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

extension BookTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text {
            let search = text.trimmingCharacters(in: .whitespaces)
            
            if !search.isEmpty {
                let request = fetchedController.fetchRequest
                request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", search)
                
                do {
                    try fetchedController.performFetch()
                } catch {
                    print("Error")
                }
                
                tableView.reloadData()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        let request = fetchedController.fetchRequest
        request.predicate = nil //assign an empty predicate to clear the controller
        
        do {
            try fetchedController.performFetch()
        } catch {
            print("Error")
        }
        
        tableView.reloadData()
    }
}


