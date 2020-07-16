//
//  addRegistrationTableViewController.swift
//  Hotel
//
//  Created by Павел on 19.05.2020.
//  Copyright © 2020 Павел. All rights reserved.
//

import UIKit

class addRegistrationTableViewController: UITableViewController, selectRoomTypeTableViewControllerDelegate, UITextFieldDelegate, registrationTableViewControllerDelegate {
 
    weak var delegate: addRegistrationTableViewControllerDelegate?
    
    var registrations: [Information] = []
     
    
    
    func didSelect(roomType: RoomType){
        self.roomType = roomType
        tableView.reloadData()
        updateRoomType()
    }
   
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var checkInDateLabel: UITableViewCell!
    @IBOutlet weak var checkInDatePicker: UIDatePicker!
    @IBOutlet weak var checkOutDateLabel: UITableViewCell!
    @IBOutlet weak var checkOutDatePicker: UIDatePicker!
    
    @IBOutlet weak var numberOfAdultsLabel: UILabel!
    @IBOutlet weak var numberOfAdultsStepper: UIStepper!
    @IBOutlet weak var numberOfChildrenLabel: UILabel!
    @IBOutlet weak var numberOfChildrenStepper: UIStepper!
    
    @IBOutlet weak var wifiSwitch: UISwitch!
    
    @IBOutlet weak var roomTypeLabel: UILabel!
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        tableView.reloadData()
    }
    
    
    
    var roomType: RoomType?
    
    func updateRoomType(){
        if let roomType = roomType{
            roomTypeLabel.text = roomType.name
           
        } else {
            roomTypeLabel.text = "Not set"
        }
        
        
    }
    func updateDateViews(){
        checkOutDatePicker.minimumDate = checkInDatePicker.date.addingTimeInterval(86400)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        checkInDateLabel.detailTextLabel?.text = dateFormatter.string(from: checkInDatePicker.date)
        checkOutDateLabel.detailTextLabel?.text = dateFormatter.string(from: checkOutDatePicker.date)
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker){
        updateDateViews()
    }
    
    
    var checkInDatePickerCellIndexPath = IndexPath(row: 1, section: 1)
    var checkOutDatePickerCellIndexPath = IndexPath(row: 3, section: 1)
    var checkInDateLabelCellIndexPath = IndexPath(row: 0, section: 1)
    var checkOutDateLabelCellIndexPath = IndexPath(row: 2, section: 1)
    
    var isCheckInDatePickerShown: Bool = false{
        didSet{
            checkInDatePicker.isHidden = !isCheckInDatePickerShown
        }
    }
    
    var isCheckOutDatePickerShown: Bool = false{
        didSet{
            checkOutDatePicker.isHidden = !isCheckOutDatePickerShown
        }
    }
    
    func updateNumberOfGuests(){
        numberOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.value))"
        numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
    }
    
    
    @IBAction func stepperValueChanged(_ stepper: UIStepper){
        updateNumberOfGuests()
    }
    
    @IBAction func wifiSwitchChanged(_ stepper: UISwitch){
        registration?.wifi = wifiSwitch.isOn
    }
    
        
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        let midnightToday = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = midnightToday
        checkInDatePicker.date = midnightToday
        updateNumberOfGuests()
        updateDateViews()
        updateRoomType()
        
        if let registration = registration{
            
            firstNameTextField.text = registration.firstName
            lastNameTextField.text = registration.lastName
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            checkInDateLabel.detailTextLabel?.text = dateFormatter.string(from: registration.inDate)
            checkOutDateLabel.detailTextLabel?.text = dateFormatter.string(from: registration.outDate)
            numberOfAdultsLabel.text = "\(registration.numberAdults)"
            numberOfChildrenLabel.text = "\(registration.numberChildren)"
            roomTypeLabel.text = registration.room.name
            wifiSwitch.isOn = registration.wifi
            self.roomType = registration.room
            doneButton.isEnabled = false
            updateDoneButtonState()
            tableView.reloadData()
        }
    }
    
    func updateDoneButtonState(){
        let name = firstNameTextField.text ?? ""
        let lastname = lastNameTextField.text ?? ""
        let room = roomTypeLabel.text
        if room != "Not set"{
        doneButton.isEnabled = !name.isEmpty && !lastname.isEmpty
    }
    }
    
    @IBAction func textEdit(_ sender: UITextField){
        updateDoneButtonState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateRoomType()
        doneButton.isEnabled = false
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "SelectRoomType"{
            let destinationViewController = segue.destination as? SelectRoomTypeTableViewController
            destinationViewController?.delegate = self
            destinationViewController?.roomType = roomType
            print(roomType)
             } else {
            doneButton.isEnabled = false
            print("\(roomType)")
            let firstName = firstNameTextField.text ?? ""
            print("\(firstName)")
            let lastName = lastNameTextField.text ?? ""
            let email = emailTextField.text ?? ""
            let checkInDate = checkInDatePicker.date
            let checkOutDate = checkOutDatePicker.date
            let numberOfAdults = Int(numberOfAdultsStepper.value)
            let numberOfChildren = Int(numberOfChildrenStepper.value)
                
            let hasWIFI = wifiSwitch.isOn
            
            guard let roomType = roomType else {return}
            
            registration = Information(firstName: firstName, lastName: lastName, email: email, inDate: checkInDate, outDate: checkOutDate, numberAdults: numberOfAdults, numberChildren: numberOfChildren, room: roomType, wifi: hasWIFI)
            Information.saveToFile(information: registrations)
        }
    }
    
  

    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        return true
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case checkInDatePickerCellIndexPath:
            if isCheckInDatePickerShown{
                return 216.0
            } else {
                return 0
            }
        case checkOutDatePickerCellIndexPath:
            if isCheckOutDatePickerShown{
                return 216.0
            } else {
                return 0
            }
        default: return 44.0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath{
        case checkInDateLabelCellIndexPath:
            if isCheckInDatePickerShown{
                isCheckInDatePickerShown = false
            } else if isCheckOutDatePickerShown{
                isCheckOutDatePickerShown = false
                isCheckInDatePickerShown = true
            } else {
                isCheckInDatePickerShown = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
            
        case checkOutDateLabelCellIndexPath :
            if isCheckOutDatePickerShown{
                isCheckOutDatePickerShown = false
            } else if isCheckInDatePickerShown{
                isCheckInDatePickerShown = false
                isCheckOutDatePickerShown = true
            } else {
                isCheckOutDatePickerShown = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
            
        default: break
        }
        
    }
    

    
    var  registration: Information?

}

protocol addRegistrationTableViewControllerDelegate: class {
    
}
