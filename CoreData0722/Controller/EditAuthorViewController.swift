//
//  EditAuthorViewController.swift
//  CoreData0722
//
//  Created by leslie on 7/22/20.
//  Copyright © 2020 leslie. All rights reserved.
//

import UIKit
import CoreData

//TODO: - 7 Inserting new authors
class EditAuthorViewController: UIViewController {

    @IBOutlet weak var authorName: UITextField!
    
    var context: NSManagedObjectContext!
    var selectedAuthor: Authors!

    override func viewDidLoad() {
        super.viewDidLoad()

        authorName.becomeFirstResponder()
        let app = UIApplication.shared
        let appDelegate = app.delegate as! AppDelegate
        context = appDelegate.context
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func saveAuthor(_ sender: UIBarButtonItem) {
        let name = authorName.text?.trimmingCharacters(in: .whitespaces)
        if name != "" {
            //TODO: - 13 Checking for duplicates
            let request: NSFetchRequest<Authors> = Authors.fetchRequest()
            request.predicate = NSPredicate(format: "name = %@", name!)
            
            if let total = try? context.count(for: request) {
                if total == 0 {
                    selectedAuthor = Authors(context: context)
                    selectedAuthor.name = name
                    
                    do {
                        try context.save()
                        performSegue(withIdentifier: "backFromNew", sender: self)
                    } catch {
                        print("Error")
                    }
                }
            }
            
//            selectedAuthor = Authors(context: context)
//            selectedAuthor.name = name
//
//            do {
//                try context.save()
//                performSegue(withIdentifier: "backFromNew", sender: self)
//            } catch {
//                print("Error")
//            }
        }
    }
}
