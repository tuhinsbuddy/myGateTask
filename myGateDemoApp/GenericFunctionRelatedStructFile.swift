//
//  GenericFunctionRelatedStructFile.swift
//  myGateDemoApp
//
//  Created by Tuhin Samui on 20/07/17.
//  Copyright © 2017 Tuhin Samui. All rights reserved.
//
import Foundation

struct GenericFunctionRelatedStruct {
    static func prepareDataForTableView(rawUnfilteredContacts contactsData: [[String: Any]], onCompletion: (_ dataFormattedWithError: Bool, _ mainTableData: [[String: Any]]) -> Void){
        var contactDetailsOfSection: [[String: Any]] = []
        var mainTableViewDataToReturn: [[String: Any]] = []
        var sectionHeaderToSort: [String] = []
        var lastFetchedSection: Character? = nil
        
        if !contactsData.isEmpty || contactsData.count > 0{
//            mainContactsTableViewData?.removeAll()
//            lastFetchedSection = nil
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
                        //                        debugPrint(lastFetchedSection)
                        if let firstLetterCheck = userNameCheck.characters.first,
                            let lastFetchedSectionCheck = lastFetchedSection,
                            firstLetterCheck != lastFetchedSectionCheck{
                            sectionHeaderToSort.append(String(lastFetchedSectionCheck))
                            let mainContactTableViewDataWithSection: [String: Any] = ["sectionHeader": String(lastFetchedSectionCheck), "sectionContactData": contactDetailsOfSection]
                            //                            debugPrint(mainContactTableViewDataWithSection)
                            mainTableViewDataToReturn.append(mainContactTableViewDataWithSection)
                            //                            debugPrint(mainContactsTableViewData)
                            contactDetailsOfSection.removeAll()
                            contactDetailsOfSection.append(contactValue)
                            lastFetchedSection = firstLetterCheck
                        } else {
                            contactDetailsOfSection.append(contactValue)
                        }
                    }
                }
            }
        }
        
        
        if !mainTableViewDataToReturn.isEmpty{
//            debugPrint(sectionHeaderToSort)
            sectionHeaderToSort = sectionHeaderToSort.sorted()
            var sortedTableViewDataToReturn: [[String: Any]] = []
//            debugPrint(sectionHeaderToSort)
            
            for sectionHeaderValue in sectionHeaderToSort {
                for dataObject in mainTableViewDataToReturn{
                    if let sectionHeaderCheck = dataObject["sectionHeader"] as? String,
                        sectionHeaderCheck == sectionHeaderValue{
                        sortedTableViewDataToReturn.append(dataObject)
                        break
                    } else {
                        continue
                    }
                }
            }
            onCompletion(false, sortedTableViewDataToReturn)
        } else {
            onCompletion(true, [])
        }
    }
}
