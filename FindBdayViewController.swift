//
//  findBdayViewController.swift
//  BirthdayFinder
//  Created by Hari Patel on 4/29/22.
//

import UIKit
import Contacts
import ContactsUI

protocol FindBdayViewControllerDelegate {
  func didFetchContacts(_ contacts: [CNContact])
}

class FindBdayViewController: UIViewController {
  
  @IBOutlet weak var txtLastName: UITextField!
  @IBOutlet weak var pickerMonth: UIPickerView!
  
  let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
  
  var currentlySelectedMonthIndex = 1
  var delegate: FindBdayViewControllerDelegate!
  
  override func viewDidLoad() {
    super.viewDidLoad()
      pickerMonth.dataSource = self
    pickerMonth.delegate = self
    txtLastName.delegate = self
    
    let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(FindBdayViewController.performDoneItemTap))
    navigationItem.rightBarButtonItem = doneBarButtonItem
  }
}
  // MARK: IBAction functions

extension FindBdayViewController: CNContactPickerDelegate {
  @IBAction func showContacts(_ sender: AnyObject) {
    let contactPickerViewController = CNContactPickerViewController()
    
    contactPickerViewController.predicateForEnablingContact = NSPredicate(format: "birthday != nil")
    
    contactPickerViewController.delegate = self
    
    contactPickerViewController.displayedPropertyKeys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey]
    
    present(contactPickerViewController, animated: true, completion: nil)
  }
  
  func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
    delegate.didFetchContacts([contact])
    navigationController?.popViewController(animated: true)
  }
}
  
// MARK: UIPickerView Delegate and Datasource functions
extension FindBdayViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
      func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return months.count
      }
    
    
}
extension FindBdayViewController: UIPickerViewDelegate {
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return months[row]
    }
 }
  


// MARK: UITextFieldDelegate functions
extension FindBdayViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    AppDelegate.appDelegate.requestForAccess { (accessGranted) -> Void in
      if accessGranted {
        let predicate = CNContact.predicateForContacts(matchingName: self.txtLastName.text!)
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: CNContactFormatterStyle.fullName), CNContactEmailAddressesKey, CNContactBirthdayKey] as [Any]
        var contacts = [CNContact]()
        var warningMessage: String!
        
        let contactsStore = AppDelegate.appDelegate.contactStore
        do {
          contacts = try contactsStore.unifiedContacts(matching: predicate, keysToFetch: keys as! [CNKeyDescriptor])
          
          if contacts.count == 0 {
            warningMessage = "No contacts were found matching the given name."
          }
        } catch {
          warningMessage = "Unable to fetch contacts."
        }
        
        
        if let warningMessage = warningMessage {
          DispatchQueue.main.async {
            Helper.show(message: warningMessage)
          }
        } else {
          DispatchQueue.main.async {
            self.delegate.didFetchContacts(contacts)
            self.navigationController?.popViewController(animated: true)
          }
        }
      }
    }
    
    return true
  }
  
  // MARK: Custom functions
  
  @objc func performDoneItemTap() {
    AppDelegate.appDelegate.requestForAccess { (accessGranted) -> Void in
      if accessGranted {
        var contacts = [CNContact]()
        
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: CNContactFormatterStyle.fullName), CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey] as [Any]
        
        do {
          let contactStore = AppDelegate.appDelegate.contactStore
          try contactStore.enumerateContacts(with: CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])) { [weak self] (contact, pointer) -> Void in
            
            if contact.birthday != nil && contact.birthday!.month == self?.currentlySelectedMonthIndex {
              contacts.append(contact)
            }
          }
          
          DispatchQueue.main.async {
            self.delegate.didFetchContacts(contacts)
            self.navigationController?.popViewController(animated: true)
          }
        }
        catch let error as NSError {
          print(error.description, separator: "", terminator: "\n")
        }
      }
    }
  }
}
