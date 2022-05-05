//
//  NewBdayViewController.swift
//  BirthdayFinder
//  Created by Hari Patel on 4/29/22.
//

import UIKit
import Contacts

class NewBdayViewController: UIViewController, UITextFieldDelegate{
  
  @IBOutlet weak var txtFirstname: UITextField!
  @IBOutlet weak var txtLastname: UITextField!
  @IBOutlet weak var txtPhoneNumber: UITextField!
  @IBOutlet weak var datePicker: UIDatePicker!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
      
   let saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(NewBdayViewController.createContact))
    navigationItem.rightBarButtonItem = saveBarButtonItem
  }
    
    
    
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  // MARK: Custom functions
  
  @objc func createContact() {
    let newContact = CNMutableContact()
    
    newContact.givenName = txtFirstname.text!
    newContact.familyName = txtLastname.text!
    
    if let PhoneNumber = txtPhoneNumber.text {
      let homeEmail = CNLabeledValue(label: CNLabelHome, value: PhoneNumber as NSString)
      newContact.emailAddresses = [homeEmail]
    }
    
    let birthdayComponents = Calendar.current.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: datePicker.date)
    newContact.birthday = birthdayComponents
    
    do {
      let saveRequest = CNSaveRequest()
      saveRequest.add(newContact, toContainerWithIdentifier: nil)
      try AppDelegate.appDelegate.contactStore.execute(saveRequest)
      
      navigationController?.popViewController(animated: true)
    } catch {
      Helper.show(message: "Unable to save the new contact.")
    }
  }
}


  
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }

