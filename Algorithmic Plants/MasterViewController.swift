//
//  MasterViewController.swift
//  Algorithmic Plants
//
//  Created by Scott Tury on 11/9/19.
//  Copyright © 2019 Scott Tury. All rights reserved.
//

import UIKit
import PlantKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var plantObjects = defaultPlantCollection()
    var fractalObjects = defaultFractalCollection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = editButtonItem

        //let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        //navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

//    @objc
//    func insertNewObject(_ sender: Any) {
//        PlantObjects.insert(NSDate(), at: 0)
//        let indexPath = IndexPath(row: 0, section: 0)
//        tableView.insertRows(at: [indexPath], with: .automatic)
//    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                var object : Any
                if indexPath.section == 0 {
                    object = plantObjects[indexPath.row]
                }
                else if indexPath.section == 1 {
                    object = fractalObjects[indexPath.row]
                }
                else {
                    print("Unknown section being requested!")
                    object = Rules(name: "default", initiator: "F-F-F-F", rules: ["F" : "F-F+F+FF-F-F+F"])
                }
                
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                // TODO: Need to fix the controller!
                controller.detailItem = object
                //controller.detailItem = Rules(initiator: "F-F-F-F", rules: ["F" : "F-F+F+FF-F-F+F"])

                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                detailViewController = controller
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? plantObjects.count : fractalObjects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if indexPath.section == 0 {
            let object = plantObjects[indexPath.row]
            if let name = object.name {
                cell.textLabel!.text = name
            }
        }
        else {
            let object = fractalObjects[indexPath.row]
            cell.textLabel!.text = object.name
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                plantObjects.remove(at: indexPath.row)
            }
            else {
                fractalObjects.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

