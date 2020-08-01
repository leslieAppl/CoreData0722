//
//  ShowAuthorsTableViewController.swift
//  CoreData0722
//
//  Created by leslie on 7/31/20.
//  Copyright © 2020 leslie. All rights reserved.
//

import UIKit
import CoreData

//MARK: - Organizing the Books objects in sections
class ShowAuthorsTableViewController: UITableViewController {

    var context: NSManagedObjectContext!
    var fetchedController: NSFetchedResultsController<Books>!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 100
        
        let app = UIApplication.shared
        let appDelegate = app.delegate as! AppDelegate
        context = appDelegate.context        
        
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

    // MARK: - Table view data source
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "showAuthors", for: indexPath) as! ShowAuthorsCell
        
        updateCell(cell: cell, path: indexPath)
        
        return cell
    }

    func updateCell(cell: ShowAuthorsCell, path: IndexPath) {
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

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

}

extension ShowAuthorsTableViewController: NSFetchedResultsControllerDelegate {
    
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
    }
}

