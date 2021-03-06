//
//  AuthorsTableViewController.swift
//  CoreData0722
//
//  Created by leslie on 7/22/20.
//  Copyright © 2020 leslie. All rights reserved.
//

import UIKit
import CoreData

//TODO: 6 Listing authors
class AuthorsTableViewController: UITableViewController {

    var context: NSManagedObjectContext!
    var listOfAuthors: [Authors] = []
    var selectedAuthor: Authors!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let app = UIApplication.shared
        let appDelegate = app.delegate as! AppDelegate
        context = appDelegate.context
        
        //TODO: - 10 Counting the authors available
        let request: NSFetchRequest<Authors> = Authors.fetchRequest()
        if let total = try? context.count(for: request) {
            print("Total Author: \(total)")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let request: NSFetchRequest<Authors> = Authors.fetchRequest()
        do {
            listOfAuthors = try context.fetch(request)
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
        return listOfAuthors.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "authorsCell", for: indexPath)
        let author = listOfAuthors[indexPath.row]
        let name = author.name
        
        //TODO: - 11 Counting the books of each author
        var total = 0
        if let totalBooks = author.books {  ///To-Many relationship
            total = totalBooks.count    ///Count the number of relationship objects
        }
        cell.textLabel?.text =  "\(name!) (\(total))"

        return cell
    }
    
    ///Performing an unwind segue programmatically
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAuthor = listOfAuthors[indexPath.row]
        performSegue(withIdentifier: "backFromList", sender: self)
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
