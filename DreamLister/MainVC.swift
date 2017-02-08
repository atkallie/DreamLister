//
//  MainVC.swift
//  DreamLister
//
//  Created by Ahmed T Khalil on 2/7/17.
//  Copyright © 2017 kalikans. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //generateTestData()
        attemptFetch()
    }

    
/***********************  TABLE VIEW SET UP  *************************/
    //table view set up; notice how everything is coming from Core Data via the FRC
    @IBOutlet var tableView: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections{
            return sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections{
            return sections[section].numberOfObjects
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemCell
        
         //for clarity we configure the cell in a separate function
        configureCell(cell, indexPath)
        
        return cell
    }
    
    func configureCell(_ cellToConfigure: ItemCell, _ indexPathForCoreData:IndexPath){
        
        //poor design to use view controller to manipulate views; instead define cell manipulations in ItemCell.swift
        //pass in item object to update cell with since FRC is defined in this file
        let item = controller.object(at: indexPathForCoreData)
        
        cellToConfigure.configureCell(item)
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
/**********  FETCHED RESULTS CONTROLLER  SET UP  *****************/
    //FRC set up
    //point of FRC is to connect Core Data and Table View
    var controller:NSFetchedResultsController<Item>!
    
    //this part is optional in general for sorting, but we need it for segmenter
    var sortDescriptor = NSSortDescriptor(key: "created", ascending: false)
    @IBOutlet var segments: UISegmentedControl!
    
    @IBAction func toggleSort(_ sender: Any) {
        switch segments.selectedSegmentIndex {
        case 0:
            sortDescriptor = NSSortDescriptor(key: "created", ascending: false)
        case 1:
            sortDescriptor = NSSortDescriptor(key: "price", ascending: false)
        case 2:
            sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        default:
            break
        }
        //redo the fetch
        attemptFetch()
        //then reload the table
        tableView.reloadData()
    }
    
    //define a function to fetch the results
    func attemptFetch(){
        //what to fetch
        let fetchRequest:NSFetchRequest<Item> = Item.fetchRequest()
        
        //set the selected sort descriptor
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //already defined context in AppDelegate.swift
        //define your controller
        controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        //then do the fetch
        do{
            try controller.performFetch()
            
            controller.delegate = self
        }catch{
            print("\(error)")
        }
    }
    
    //tie the controller with the tableview
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    
    //command click on NSFetchedResultsChangeType to see what cases you need to handle
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            break
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case .update:
            
            let cell = tableView.cellForRow(at: indexPath!) as! ItemCell
            configureCell(cell, indexPath!)
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    

/********************  EDITING/DELETING ENTRY  ********************/
    
    //if you select a row and it is populated
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = controller.fetchedObjects, objs.count>0 {
            
            performSegue(withIdentifier: "itemDetails", sender: objs[indexPath.row])
        }
    }
    
    //item to edit is sent if row is selected
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemDetails"{
            if let dest = segue.destination as? ItemDetailsVC{
                if let item = sender as? Item{
                    dest.itemToEdit = item
                }
            }
        }
    }
    
    
    //deleting entries
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if let itemToDelete = controller.fetchedObjects?[indexPath.row]{
            if editingStyle == .delete{
                context.delete(itemToDelete)
                do{
                    try context.save()
                }catch{
                    print("Maybe next time, chief. You got this error: \(error)")
                }
            }
        }
    }
    
    
/***********************  TEST DATA  *************************/
    
    func generateTestData(){
        //create items in the managed object context
        let item1 = Item(context: context)
        item1.title = "Lykan Hypersport"
        item1.price = 3400000
        item1.details = "Insha Allah you will get this one day. Just don't let anyone get to you. Ever."
        
        let item2 = Item(context: context)
        item2.title = "Bugatti Veyron"
        item2.price = 2000000
        item2.details = "Insha Allah you will get this one day. Just don't let anyone get to you. Ever."
        
        let item3 = Item(context: context)
        item3.title = "Private Island"
        item3.price = 38000000
        item3.details = "Insha Allah you will get this one day. Just don't let anyone get to you. Ever."
        
        
        //not saved in persistent storage yet...
        do{
            try context.save()
        }catch{
            print("\(error)")
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

