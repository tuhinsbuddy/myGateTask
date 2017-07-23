//
//  ContactFetchingTaskStructFile.swift
//  myGateDemoApp
//
//  Created by Tuhin Samui on 19/07/17.
//  Copyright © 2017 Tuhin Samui. All rights reserved.
//

import UIKit
import Contacts

struct ContactFetchingTaskStruct {
    static let contactStoreObject = CNContactStore()
    static func requestForAccessContacts(onCompletion: @escaping (_ authenticated: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        switch authorizationStatus {
        case .authorized:
            onCompletion(true)
            
        case .denied, .notDetermined:
            ContactFetchingTaskStruct.contactStoreObject.requestAccess(for: CNEntityType.contacts, completionHandler: { (authValue, authErrorValue) -> Void in
                if authValue == true && authErrorValue == nil{
                    onCompletion(true)
                } else {
                    onCompletion(false)
                }
            })
            
        default:
            onCompletion(false)
        }
    }
    
    
    static func fetchContactsFromDevice(onCompletion: (_ contactData: [CNContact]) -> Void) {
        let predicateToMatch = CNContact.predicateForContactsInContainer(withIdentifier: ContactFetchingTaskStruct.contactStoreObject.defaultContainerIdentifier())
        let keysToFetchDetails: [Any] = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey, CNContactEmailAddressesKey, CNContactImageDataKey]
        var contactsData: [CNContact] = []
        
        if let keysToFetchDetailsCheck = keysToFetchDetails as? [CNKeyDescriptor] {
            do {
                contactsData = try ContactFetchingTaskStruct.contactStoreObject.unifiedContacts(matching: predicateToMatch, keysToFetch: keysToFetchDetailsCheck)
                onCompletion(contactsData)
            } catch {
                contactsData.removeAll()
                onCompletion(contactsData)
            }
            
        } else {
            contactsData.removeAll()
            onCompletion(contactsData)
        }
    }
    
    
    static func handlePhoneContacts(mainContactsDataFromDevice rawContactsData: [CNContact], onCompletion: (_ dataOfUsers: [[String: Any]]) -> Void){
        var contactsCompleteDataFromDevice: [[String: Any]] = []

        for (indexValue, contactData) in rawContactsData.enumerated() {
//            debugPrint(contactData)
            var phoneString: String = ""
            var nameString: String = ""
            var emailString: String = ""
            
            if contactData.phoneNumbers.count > 0 {
                phoneString = contactData.phoneNumbers[0].value.stringValue.replacingOccurrences(of: "-", with: "")
            } else {
                phoneString.removeAll()
            }
            
            if contactData.emailAddresses.count > 0 {
                emailString = contactData.emailAddresses[0].value as String
            } else {
                emailString.removeAll()
            }
            
            nameString = contactData.givenName + " " + contactData.familyName

            var newContactDetails: [String: Any] = ["userName": nameString, "isUserSelected": false, "userPhoneNumber": phoneString, "userEmailId": emailString, "selectionIndex": indexValue]
            
            if let userProfileImageCheck = contactData.imageData {
                newContactDetails.updateValue(userProfileImageCheck as Any, forKey: "userProfileImage")
            }
            
            if contactsCompleteDataFromDevice.count > 0 {
                var userAlreadyExists: Bool = false
                for contactData in contactsCompleteDataFromDevice {
                    if let contactName: String = contactData["userName"] as? String,
                        contactName == nameString{
                        userAlreadyExists = true
                    } else {
                        userAlreadyExists = false
                    }
                }
                
                if userAlreadyExists == false{
                    contactsCompleteDataFromDevice.append(newContactDetails)
                }
            } else {
                contactsCompleteDataFromDevice.append(newContactDetails)
            }
//            debugPrint(contactsCompleteDataFromDevice)
        }
        
        onCompletion(contactsCompleteDataFromDevice)
    }
}
