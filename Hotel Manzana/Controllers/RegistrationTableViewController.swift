//
//  RegistrationTableViewController.swift
//  Hotel Manzana
//
//  Created by Vladimir Pisarenko on 30.05.2022.
//

import UIKit

class RegistrationTableViewController: UITableViewController, AddRegistrationTableViewControllerDelegate {
    
    
    
    var registrations: [Registration] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        print("DidLoad in list work")
//        let name = registrations[0].firstName
//        print(name)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Will appear in list")
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return registrations.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegistrationCell", for: indexPath)
        let registration = registrations[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = registration.firstName + " " + registration.lastName
        content.secondaryText = (registration.checkInDate..<registration.checkOutDate).formatted(date: .numeric, time: .omitted) + ":" + registration.roomType.name
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            registrations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    // MARK: - AddRegistrationTableViewControllerDelegate
    
    
    func addRegistrationTableViewController(_ controller: AddRegistrationTableViewController, didSave registration: Registration) {
        
        if let indexPath = tableView.indexPathForSelectedRow {
            registrations.remove(at: indexPath.row)
            registrations.insert(registration, at: indexPath.row)
        } else {
            registrations.append(registration)
        }
        
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
        
    }
    
    
    // MARK: - Navigation
    
    @IBSegueAction func showRegistrationDetails(_ coder: NSCoder, sender: Any?) -> AddRegistrationTableViewController? {
        
        let detailViewController = AddRegistrationTableViewController(coder: coder)
        detailViewController?.delegate = self
        
        guard
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell)
        else {
            return detailViewController
        }
        
        let registration = registrations[indexPath.row]
        detailViewController?.registration = registration
        
        return detailViewController
    }
    
    @IBAction func testButtonTapped(_ sender: Any) {
        
        print(registrations)
    }
    
    @IBAction func unwindFromAddRegistration(unwindSegue:UIStoryboardSegue) {
        tableView.reloadData()
    }
    
}


