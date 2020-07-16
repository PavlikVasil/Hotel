//
//  RegistrationTableViewController.swift
//  Hotel
//
//  Created by Павел on 21.05.2020.
//  Copyright © 2020 Павел. All rights reserved.
//

import UIKit

class RegistrationTableViewController: UITableViewController, addRegistrationTableViewControllerDelegate {
    
    weak var delegate: registrationTableViewControllerDelegate?

    
    var registrations: [Information] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        if let savedInfo = Information.loadFromFile(){
            registrations = savedInfo
            print(registrations)
        } else {print("-")}
        clearsSelectionOnViewWillAppear = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = true
        //tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return registrations.count
    }

    
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
            registrations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            Information.saveToFile(information: registrations)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegistrationCell", for: indexPath)
        
        let registration = registrations[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        cell.textLabel?.text = registration.firstName + " " + registration.lastName
        cell.detailTextLabel?.text = dateFormatter.string(from: registration.inDate) + "-" + dateFormatter.string(from: registration.outDate) + registration.room.name
        
        return cell
    }
     
     
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let registration = registrations[indexPath.row]
         print("\(registration.firstName)\(indexPath)")
     }
    
    
    
    @IBAction func unwindFromAddRegistration(unwindSegue: UIStoryboardSegue){
        
        let addRegistrationTableViewController = unwindSegue.source as? addRegistrationTableViewController
        if let registration = addRegistrationTableViewController?.registration{
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                registrations[selectedIndexPath.row] = registration
                print("\(registration.room)")
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                
            } else {
                let newIndexPath = IndexPath(row: registrations.count, section: 0)
                registrations.append(registration)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                tableView.reloadData()
                print("new \(registration.room)")
            }
            Information.saveToFile(information: registrations)
        }
    }
    
    @IBAction func unwindCancel(unwindSegue: UIStoryboardSegue){
        Information.saveToFile(information: registrations)
        tableView.reloadData()
        
    }
    
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails"{
            print("+")
        
           let indexPath = tableView.indexPathForSelectedRow!
            let registration = registrations[indexPath.row]
            let navController = segue.destination as! UINavigationController
            let addRegistrationTableViewController = navController.topViewController as! addRegistrationTableViewController
            addRegistrationTableViewController.registration = registration
            
            
        }
        }
    
    
   
    
     
}

protocol registrationTableViewControllerDelegate: class {
}
