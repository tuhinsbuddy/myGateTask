//
//  GenericFunctionRelatedStructFile.swift
//  myGateDemoApp
//
//  Created by Tuhin Samui on 20/07/17.
//  Copyright © 2017 Tuhin Samui. All rights reserved.
//
import Foundation

struct GenericFunctionRelatedStruct {
    static func prepareDataForTableView(rawUnfilteredContacts contactsData: [[String: Any]], onFirstLoad isFirstLoad: Bool, onCompletion: (_ dataFormattedWithError: Bool, _ mainTableData: [[String: Any]], _ finalContactDetailsFromDevice: [[String: Any]], _ firstTimeLoad: Bool) -> Void){
        var contactDetailsOfSection: [[String: Any]] = []
        var mainTableViewDataToReturn: [[String: Any]] = []
        var sectionHeaderToSort: [String] = []
        var lastFetchedSection: Character? = nil
//        debugPrint(contactsData)
        
        if !contactsData.isEmpty || contactsData.count > 0{
            for contactValue in contactsData {
                //                debugPrint(contactValue)
                if lastFetchedSection == nil {
                    contactDetailsOfSection.append(contactValue)
                    if let userNameCheck = contactValue["userName"] as? String,
                        !userNameCheck.isEmpty,
                        let firstLetterCheck = userNameCheck.characters.first{
                        lastFetchedSection = firstLetterCheck
                    }
                } else {
                    if let userNameCheck = contactValue["userName"] as? String,
                        !userNameCheck.isEmpty{
                        if let firstLetterCheck = userNameCheck.characters.first,
                            let lastFetchedSectionCheck = lastFetchedSection,
                            firstLetterCheck != lastFetchedSectionCheck{
                            sectionHeaderToSort.append(String(lastFetchedSectionCheck))
                            
                            for contactValueIndex in 0..<contactDetailsOfSection.count {
                                contactDetailsOfSection[contactValueIndex].updateValue(contactValueIndex, forKey: "sectionCellIndex")
                                contactDetailsOfSection[contactValueIndex].updateValue(contactValueIndex, forKey: "sectionHeaderIndex")
                            }
                            
                            
                            let mainContactTableViewDataWithSection: [String: Any] = ["sectionHeader": String(lastFetchedSectionCheck), "sectionContactData": contactDetailsOfSection]
                            mainTableViewDataToReturn.append(mainContactTableViewDataWithSection)
                            contactDetailsOfSection.removeAll()
                            contactDetailsOfSection.append(contactValue)
                            lastFetchedSection = firstLetterCheck
                        } else {
                            contactDetailsOfSection.append(contactValue)
                        }
                    }
                }
            }
            //            debugPrint(mainTableViewDataToReturn)
        }
        
        if contactDetailsOfSection.count > 0 {
            //            debugPrint(contactDetailsOfSection)
            if let lastFetchedSectionCheck = lastFetchedSection{
                sectionHeaderToSort.append(String(lastFetchedSectionCheck))
                
                for contactValueIndex in 0..<contactDetailsOfSection.count {
                    contactDetailsOfSection[contactValueIndex].updateValue(contactValueIndex, forKey: "sectionCellIndex")
                    contactDetailsOfSection[contactValueIndex].updateValue(contactValueIndex, forKey: "sectionHeaderIndex")
                }
                
                let mainContactTableViewDataWithSection: [String: Any] = ["sectionHeader": String(lastFetchedSectionCheck), "sectionContactData": contactDetailsOfSection]
                contactDetailsOfSection.removeAll()
                lastFetchedSection = nil
                mainTableViewDataToReturn.append(mainContactTableViewDataWithSection)
            }
        }
        
        
        if mainTableViewDataToReturn.count > 1{
            sectionHeaderToSort = sectionHeaderToSort.sorted()
            var sortedTableViewDataToReturn: [[String: Any]] = []
            var finalContactDetailsFromDevice: [[String: Any]] = []
            var lastSectionIndex: Int = 0
            for sectionHeaderValue in sectionHeaderToSort {
                for dataObject in mainTableViewDataToReturn{
                    if let sectionHeaderCheck = dataObject["sectionHeader"] as? String,
                        sectionHeaderCheck == sectionHeaderValue{
                        
                        var datToAppend = dataObject
                        
                        if let sectionContactDataCheck = datToAppend["sectionContactData"] as? [[String: Any]],
                            !sectionContactDataCheck.isEmpty {
                            var sectionContactObject = [[String: Any]]()
                            for value in sectionContactDataCheck{
                                var valueObject = value
                                valueObject.updateValue(lastSectionIndex, forKey: "sectionHeaderIndex")
                                sectionContactObject.append(valueObject)
                                if isFirstLoad == true {
                                    finalContactDetailsFromDevice.append(valueObject)
                                }
                            }
                            
                            datToAppend.updateValue(sectionContactObject, forKey: "sectionContactData")
                        }
                        sortedTableViewDataToReturn.append(datToAppend)
                        lastSectionIndex += 1
                        break
                    } else {
                        continue
                    }
                }
            }
            
            if isFirstLoad == true {
                finalContactDetailsFromDevice.sort(by: {(firstObject, secondObject) -> Bool in
                    if let firstObjectValue = firstObject["selectionIndex"] as? Int,
                        let secondObjectValue = secondObject["selectionIndex"] as? Int{
                        return firstObjectValue < secondObjectValue
                    } else {
                        return false
                    }
                    
                })
            }
            
//            debugPrint(finalContactDetailsFromDevice)
            
            onCompletion(false, sortedTableViewDataToReturn, finalContactDetailsFromDevice, isFirstLoad)
        } else if !mainTableViewDataToReturn.isEmpty{
            var finalContactDetailsFromDevice: [[String: Any]] = []
            
            if let sectionContactDataCheck = mainTableViewDataToReturn[0]["sectionContactData"] as? [[String: Any]],
                !sectionContactDataCheck.isEmpty {
                var sectionContactObject = [[String: Any]]()
                for value in sectionContactDataCheck{
                    var valueObject = value
                    valueObject.updateValue(0, forKey: "sectionHeaderIndex")
                    sectionContactObject.append(valueObject)
                    if isFirstLoad == true {
                        finalContactDetailsFromDevice.append(valueObject)
                    }
                }
                mainTableViewDataToReturn[0].updateValue(sectionContactObject, forKey: "sectionContactData")
            }
            
            if isFirstLoad == true {
                finalContactDetailsFromDevice.sort(by: {(firstObject, secondObject) -> Bool in
                    if let firstObjectValue = firstObject["selectionIndex"] as? Int,
                        let secondObjectValue = secondObject["selectionIndex"] as? Int{                        return firstObjectValue < secondObjectValue
                    } else {
                        return false
                    }
                    
                })
            }
            
//            debugPrint(finalContactDetailsFromDevice)
            onCompletion(false, mainTableViewDataToReturn, finalContactDetailsFromDevice, isFirstLoad)
        } else {
            onCompletion(true, [], [], true)
        }
    }
}
