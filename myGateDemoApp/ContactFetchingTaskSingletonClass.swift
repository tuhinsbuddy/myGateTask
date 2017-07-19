//
//  ContactFetchingTaskSingletonClass.swift
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
        var mainContactsTableViewData: [[String: Any]] = [] //[["sectionHeader": "A", "sectionContactData": [[String: Any]]()]]
        var contactsCompleteDataFromDevice: [[String: Any]] = []//[["userName": "Tuhin Samui", "userPhoneNumber": "+919126239323", "userProfileImage": UIImage(), "isUserSelected": false]]
        var lastFetchedSection: Character = "A"
        
//        var phoneContactsToSave: [[String: Any]] = []
        for contactData in rawContactsData {
            debugPrint(contactData)
            var phoneString: String = ""
            var nameString: String = ""
            var emailString: String = ""
            var currentSection: Bool = false
            
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
            
            
            
            
//            if nameString.isEmpty{
//                nameString = "No User Name Found!"
//            } else {
////                var firstCharcterOfUserName: String = ""
//                debugPrint(lastFetchedSection)
//                debugPrint(nameString.characters.first)
//
//                if let firstLetterCheck = nameString.characters.first,
//                    firstLetterCheck != lastFetchedSection{
//                    currentSection = false
//                    
////                    if currentSection == false {
//                        for contactValueIndex in 0..<contactsCompleteDataFromDevice.count {
//                            if let _: Int = contactsCompleteDataFromDevice[contactValueIndex]["selectionIndex"] as? Int {
//                                contactsCompleteDataFromDevice[contactValueIndex].updateValue(contactValueIndex, forKey: "selectionIndex")
//                            }
//                        }
//                        
//                        let mainContactDetailsToReturn: [String: Any] = ["sectionHeader": String(lastFetchedSection), "sectionContactData": contactsCompleteDataFromDevice]
//                    debugPrint(mainContactDetailsToReturn)
//                        mainContactsTableViewData.append(mainContactDetailsToReturn)
//                    debugPrint(mainContactsTableViewData)
//                        contactsCompleteDataFromDevice.removeAll()
//                        lastFetchedSection = firstLetterCheck
//
////                    }
//                    
//                    
//                } else {
//                    currentSection = true
////                    contactsCompleteDataFromDevice.removeAll()
//                }
//            }
            
            

            
            var newContactDetails: [String: Any] = ["userName": nameString, "isUserSelected": false, "userPhoneNumber": phoneString, "userEmailId": emailString, "selectionIndex": Int()]
//            let newContactToSave: [String: Any] = ["nameString": nameString, "contactPhoneValue": phoneString, "email": emailString]
            
            
            if let userProfileImageCheck = contactData.imageData {
                newContactDetails.updateValue(userProfileImageCheck as Any, forKey: "userProfileImage")
            }
            
            debugPrint(newContactDetails)

            
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
            debugPrint(contactsCompleteDataFromDevice)
        }
        
        
        debugPrint(mainContactsTableViewData)
        
        onCompletion(contactsCompleteDataFromDevice)

        
        
        
        
//        if contactsTable.count != 0 && dummyDataToRemove.count != 0 {
//            if let nameStringCheck: String = contactsTable[0]["nameString"] as? String {
//                if nameStringCheck != "showLoader" && nameStringCheck != "No result found!" && nameStringCheck != "No Contacts found!"{
//                    
//                    if let contactUploadedCheck = UserDefaults.standard.object(forKey: "uploadedAllPhoneContactsToServerForSlicepayiOS") as? Bool {
//                        switch contactUploadedCheck {
//                        case true:
//                            debugPrint("Contacts already uploaded to the server in phone contacts")
//                            
//                        case false:
//                            if let _ = UserDefaults.standard.object(forKey: "=\'9D/R-8:)$UyM8>mHym?C<-rjtTry;pUH<JHYb#<v5X9xh}yzWPeYNDUKKrqx!wUASd") as? [[String: Any]] {
//                                ContactAccessSingletonClass.singletonObjectForContactAccessClass.mainContactUploadController()
//                                
//                            } else {
//                                if !phoneContactsToSave.isEmpty {
//                                    UserDefaults.standard.set(phoneContactsToSave, forKey: "=\'9D/R-8:)$UyM8>mHym?C<-rjtTry;pUH<JHYb#<v5X9xh}yzWPeYNDUKKrqx!wUASd")
//                                    //                                                    defaultsToUpdate.setObject(contactsTable, forKey: "allPhoneContactsToSelect")
//                                    
//                                } else {
//                                    UserDefaults.standard.set(contactsTable, forKey: "=\'9D/R-8:)$UyM8>mHym?C<-rjtTry;pUH<JHYb#<v5X9xh}yzWPeYNDUKKrqx!wUASd")
//                                }
//                                ContactAccessSingletonClass.singletonObjectForContactAccessClass.mainContactUploadController()
//                            }
//                            
//                            
//                        }
//                    } else {
//                        UserDefaults.standard.setValue(false, forKey: "uploadedAllPhoneContactsToServerForSlicepayiOS")
//                        if !phoneContactsToSave.isEmpty {
//                            UserDefaults.standard.set(phoneContactsToSave, forKey: "=\'9D/R-8:)$UyM8>mHym?C<-rjtTry;pUH<JHYb#<v5X9xh}yzWPeYNDUKKrqx!wUASd")
//                            //                            defaultsToUpdate.setObject(contactsTable, forKey: "allPhoneContactsToSelect")
//                            
//                            
//                        } else {
//                            UserDefaults.standard.set(contactsTable, forKey: "=\'9D/R-8:)$UyM8>mHym?C<-rjtTry;pUH<JHYb#<v5X9xh}yzWPeYNDUKKrqx!wUASd")
//                            //                            defaultsToUpdate.setObject(contactsTable, forKey: "allPhoneContactsToSelect")
//                            
//                        }
//                        ContactAccessSingletonClass.singletonObjectForContactAccessClass.mainContactUploadController()
//                    }
//                    removeContactsFromNewArray(mainData: contactsTable, removeableData: dummyDataToRemove)
//                } else {
//                    reloadTableAsPerTheCurrentSegment()
//                }
//            }
//        } else {
//            if contactsTable.count != 0 {
//                if let nameStringCheck: String = contactsTable[0]["nameString"] as? String {
//                    if nameStringCheck != "showLoader" && nameStringCheck != "No result found!" && nameStringCheck != "No Contacts found!"{
//                        //                        defaultsToUpdate.setObject(contactsTable, forKey: "allPhoneContactsToSelect")
//                        
//                        if let contactUploadedCheck = UserDefaults.standard.object(forKey: "uploadedAllPhoneContactsToServerForSlicepayiOS") as? Bool {
//                            switch contactUploadedCheck {
//                            case true:
//                                debugPrint("Contacts already uploaded to the server in phone contacts")
//                                
//                            case false:
//                                
//                                if let _ = UserDefaults.standard.object(forKey: "=\'9D/R-8:)$UyM8>mHym?C<-rjtTry;pUH<JHYb#<v5X9xh}yzWPeYNDUKKrqx!wUASd") as? [[String: Any]] {
//                                    ContactAccessSingletonClass.singletonObjectForContactAccessClass.mainContactUploadController()
//                                    
//                                } else {
//                                    if !phoneContactsToSave.isEmpty {
//                                        UserDefaults.standard.set(phoneContactsToSave, forKey: "=\'9D/R-8:)$UyM8>mHym?C<-rjtTry;pUH<JHYb#<v5X9xh}yzWPeYNDUKKrqx!wUASd")
//                                        //                                        defaultsToUpdate.setObject(contactsTable, forKey: "allPhoneContactsToSelect")
//                                        
//                                    } else {
//                                        UserDefaults.standard.set(contactsTable, forKey: "=\'9D/R-8:)$UyM8>mHym?C<-rjtTry;pUH<JHYb#<v5X9xh}yzWPeYNDUKKrqx!wUASd")
//                                        //                                        defaultsToUpdate.setObject(contactsTable, forKey: "allPhoneContactsToSelect")
//                                        
//                                    }
//                                    ContactAccessSingletonClass.singletonObjectForContactAccessClass.mainContactUploadController()
//                                }
//                            }
//                        } else {
//                            UserDefaults.standard.setValue(false, forKey: "uploadedAllPhoneContactsToServerForSlicepayiOS")
//                            
//                            if !phoneContactsToSave.isEmpty {
//                                UserDefaults.standard.set(phoneContactsToSave, forKey: "=\'9D/R-8:)$UyM8>mHym?C<-rjtTry;pUH<JHYb#<v5X9xh}yzWPeYNDUKKrqx!wUASd")
//                                //                                defaultsToUpdate.setObject(contactsTable, forKey: "allPhoneContactsToSelect")
//                                
//                            } else {
//                                UserDefaults.standard.set(contactsTable, forKey: "=\'9D/R-8:)$UyM8>mHym?C<-rjtTry;pUH<JHYb#<v5X9xh}yzWPeYNDUKKrqx!wUASd")
//                                //                                defaultsToUpdate.setObject(contactsTable, forKey: "allPhoneContactsToSelect")
//                                
//                            }
//                            ContactAccessSingletonClass.singletonObjectForContactAccessClass.mainContactUploadController()
//                        }
//                    }
//                }
//            }
//            
//            reloadTableAsPerTheCurrentSegment()
//        }
    }
    
    
    
}

//class ContactFetchingTaskSingletonClass: NSObject {
//    static let ContactFetchingTaskClassInstance = ContactFetchingTaskSingletonClass()
//    var contactStoreObject = CNContactStore()
//    
//    func requestForAccess(onCompletion: @escaping (_ authenticated: Bool) -> Void) {
//        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
//        
//        switch authorizationStatus {
//        case .authorized:
//            onCompletion(true)
//            
//        case .denied, .notDetermined:
//            ContactFetchingTaskSingletonClass.ContactFetchingTaskClassInstance.contactStoreObject.requestAccess(for: CNEntityType.contacts, completionHandler: { (authValue, authErrorValue) -> Void in
//                if authValue == true && authErrorValue != nil{
//                    onCompletion(true)
//                } else {
//                    onCompletion(false)
//                }
//            })
//            
//        default:
//            onCompletion(false)
//        }
//    }
//    
//
//}
