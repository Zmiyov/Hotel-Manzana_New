//
//  AddRegistrationTableViewController.swift
//  Hotel Manzana
//
//  Created by Vladimir Pisarenko on 27.05.2022.
//

import UIKit

protocol AddRegistrationTableViewControllerDelegate: AnyObject {
    func addRegistrationTableViewController(_ controller: AddRegistrationTableViewController, didSave registration: Registration)
}

class AddRegistrationTableViewController: UITableViewController, SelectRoomTypeTableViewControllerDelegate {
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var checkInDateLabel: UILabel!
    @IBOutlet var checkInDatePicker: UIDatePicker!
    @IBOutlet var checkOutDateLabel: UILabel!
    @IBOutlet var checkOutDatePicker: UIDatePicker!
    
    @IBOutlet var numberOfAdultsLabel: UILabel!
    @IBOutlet var numberOfAdutsStepper: UIStepper!
    @IBOutlet var numberOfChildrenLabel: UILabel!
    @IBOutlet var numberOfChildrenStepper: UIStepper!
    
    @IBOutlet var wifiSwitch: UISwitch!
    
    @IBOutlet var roomTypeLabel: UILabel!
    
    @IBOutlet var doneButtonLabel: UIBarButtonItem!
    
    @IBOutlet var chargesNumberOfNightsLabel: UILabel!
    @IBOutlet var chargesNumberOfNightsDatesLabel: UILabel!
    @IBOutlet var chargesSummForRoomLabel: UILabel!
    @IBOutlet var chargesRoomDescriptionLabel: UILabel!
    @IBOutlet var chargesSummForWifiLabel: UILabel!
    @IBOutlet var chargesWifiStatusLabel: UILabel!
    @IBOutlet var chargesTotalSumLabel: UILabel!
    
    let checkInDateLabelIndexPath = IndexPath(row: 0, section: 1)
    let checkInDatePickerCellIndexPath = IndexPath(row: 1, section: 1)
    let checkOutDateLabelIndexPath = IndexPath(row: 2, section: 1)
    let checkOutDatePickerCellIndexPath = IndexPath(row: 3, section: 1)
    
    var isCheckInDatePickerVisible: Bool = false {
        didSet {
            checkInDatePicker.isHidden = !isCheckInDatePickerVisible
        }
    }
    var isCheckOutDatePickerVisible: Bool = false {
        didSet {
            checkOutDatePicker.isHidden = !isCheckOutDatePickerVisible
        }
    }
    
    weak var delegate: AddRegistrationTableViewControllerDelegate?
    
    var roomType: RoomType?
    
    var registration: Registration?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let midnightToday = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = midnightToday
        checkInDatePicker.date = midnightToday
    
        if self.registration == nil {
            doneButtonLabel.isEnabled = false
        }
        
        updateDateViews()
        updateNumberOfGuest()
        updateRoomType()

        updateVC()
        
        print("work!")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateDoneButtonState()
        charges()
    }
    
    func updateVC() {
        if let item = registration {
           // navigationItem.title = item.firstName
            firstNameTextField.text = item.firstName
            lastNameTextField.text = item.lastName
            emailTextField.text = item.eMailAdress
            checkInDatePicker.date = item.checkInDate
            checkOutDatePicker.date = item.checkOutDate
            numberOfAdutsStepper.value = Double(item.numberOfAdults)
            numberOfChildrenStepper.value = Double(item.numberOfChildren)
            wifiSwitch.isOn = item.wiFi
            roomType = item.roomType
//        } else {
//            navigationItem.title = "New Registration"
        }
    }
    
    private func updateDoneButtonState() {
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        doneButtonLabel.isEnabled = !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && (numberOfAdultsLabel.text != "0" || numberOfChildrenLabel.text != "0") && roomTypeLabel.text != "Not set"
    }
    
    func selectRoomTypeTableVievController(_ controler: SelectRoomTypeTableViewController, didSelect roomType: RoomType) {
        self.roomType = roomType
        updateRoomType()
    }
    
    func updateDateViews () {
        checkOutDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: checkInDatePicker.date)
        checkInDateLabel.text = checkInDatePicker.date.formatted(date: .abbreviated, time: .omitted)
        checkOutDateLabel.text = checkOutDatePicker.date.formatted(date: .abbreviated, time: .omitted)
    }
    
    func updateNumberOfGuest() {
        numberOfAdultsLabel.text = "\(Int(numberOfAdutsStepper.value))"
        numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
    }
    
    func updateRoomType() {
        if let roomType = roomType {
            roomTypeLabel.text = roomType.name
        } else {
            roomTypeLabel.text = "Not set"
        }
    }
    
   
    
    func charges() {
        let daysAmounth = Calendar.current.dateComponents([.day], from: checkInDatePicker.date, to: checkOutDatePicker.date)
        if let numberOfNights = daysAmounth.day {
            chargesNumberOfNightsLabel.text = "\(numberOfNights)"
            chargesNumberOfNightsDatesLabel.text = checkInDatePicker.date.formatted(date: .abbreviated, time: .omitted) + " - " + checkOutDatePicker.date.formatted(date: .abbreviated, time: .omitted)
            
            let summForRoom = numberOfNights * (roomType?.price ?? 0)
            chargesSummForRoomLabel.text = "\(summForRoom)"
            chargesRoomDescriptionLabel.text = (roomType?.name ?? "") + "@" + "\(roomType?.price ?? 0)" + "/night"
            
            if wifiSwitch.isOn {
                let summForWifi = numberOfNights * 10
                chargesSummForWifiLabel.text = "\(summForWifi)"
                chargesWifiStatusLabel.text = "Yes"
                let summTotal = summForRoom + summForWifi
                chargesTotalSumLabel.text = "\(summTotal)"
            } else {
                let summForWifi = 0
                chargesSummForWifiLabel.text = "\(summForWifi)"
                chargesWifiStatusLabel.text = "No"
                let summTotal = summForRoom + summForWifi
                chargesTotalSumLabel.text = "\(summTotal)"
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case checkInDatePickerCellIndexPath where
            isCheckInDatePickerVisible == false:
            return 0
        case checkOutDatePickerCellIndexPath where
            isCheckOutDatePickerVisible == false:
            return 0
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case checkInDatePickerCellIndexPath:
            return 190
        case checkOutDatePickerCellIndexPath:
            return 190
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath == checkInDateLabelIndexPath && isCheckOutDatePickerVisible == false {
            isCheckInDatePickerVisible.toggle()
        } else if indexPath == checkOutDateLabelIndexPath && isCheckInDatePickerVisible == false {
            isCheckOutDatePickerVisible.toggle()
        } else if indexPath == checkInDateLabelIndexPath || indexPath == checkOutDateLabelIndexPath {
            isCheckInDatePickerVisible.toggle()
            isCheckOutDatePickerVisible.toggle()
        } else {
            return
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        guard let roomType = roomType,
              let firstName = firstNameTextField.text,
              let lastName = lastNameTextField.text,
              let email = emailTextField.text else {return}
              let checkInDate = checkInDatePicker.date
              let checkOutDate = checkOutDatePicker.date
              let numberOfAdults = Int(numberOfAdutsStepper.value)
              let numberOfChildren = Int(numberOfChildrenStepper.value)
              let hasWifi = wifiSwitch.isOn
        
        let registration = Registration(firstName: firstName, lastName: lastName, eMailAdress: email, checkInDate: checkInDate, checkOutDate: checkOutDate, numberOfAdults: numberOfAdults, numberOfChildren: numberOfChildren, wiFi: hasWifi, roomType: roomType)
        
        delegate?.addRegistrationTableViewController(self, didSave: registration)
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any?) {
        registration = nil
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
        charges()
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        updateNumberOfGuest()
        updateDoneButtonState()
    }
    
    @IBAction func wifiSwitchChanged(_ sender: UISwitch) {
        charges()
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateDoneButtonState()
    }
   
    @IBSegueAction func selectRoomType(_ coder: NSCoder) -> SelectRoomTypeTableViewController? {
        let selectRoomTypeController = SelectRoomTypeTableViewController(coder: coder)
        selectRoomTypeController?.delegate = self
        selectRoomTypeController?.roomType = roomType
        return selectRoomTypeController
    }
}
