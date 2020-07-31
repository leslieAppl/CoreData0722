# CoreData

# Branch: master - Working with Array in TableView

## Creating CoreData Model

## Initializing the Core Data stack in the app’s delegate

## Accessing the context from a view controller

## Fetching values from the Persistent Store

## Adding an author to the book

## Listing authors

## Inserting new authors

## Binary Data | UIImage

## Counting Objects

## Predicate | Filtering

## Predicate | Checking for duplicates

## Sorting

## Deleting Object

# Branch: WorkingWithNSFetchedResultsController

## Migration

## Fetching objects with an NSFetchedResultsController object

## Organizing the Books objects in sections

## Debugged @ BookTableViewController
- Invalid update: invalid number of sections in UITableView
- with implementing the next code:

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



