//
//  ContactsMainViewController.swift
//  myGateDemoApp
//
//  Created by Tuhin Samui on 16/07/17.
//  Copyright © 2017 Tuhin Samui. All rights reserved.
//

import UIKit
import Contacts
import Kingfisher

class ContactsMainViewController: UIViewController {
    
    @IBOutlet weak var contactDetailsTopFavouriteSuperViewHeight: NSLayoutConstraint!
    @IBOutlet weak var favouriteSelectedContactsMainCollectionView: UICollectionView!
    @IBOutlet weak var contactSearchMainSuperView: UIView!
    @IBOutlet weak var contactDetailsMainStackView: UIStackView!
    @IBOutlet weak var contactDetailsTopFavouriteSuperView: UIView!
    @IBOutlet weak var contactDetailsMainTableViewSuperView: UIView!
    @IBOutlet weak var contactDetailsMainTableView: UITableView!
    @IBOutlet weak var getAllContactsBtn: UIButton!
    @IBOutlet weak var authenticationMainSuperView: UIView!
    @IBOutlet weak var contactDetailsMainSuperView: UIView!
    
    fileprivate var selectedContactsClicked: Bool = false
    fileprivate let searchBarController = UISearchController(searchResultsController: nil)
    fileprivate var searchedContactsData: [[String: Any]] = []
    fileprivate var mainContactsTableViewData: [[String: Any]]? = [] //[["sectionHeader": "A", "sectionContactData": [[String: Any]]()]]
    fileprivate var contactsCompleteDataFromDevice: [[String: Any]] = [] //[["userName": "Tuhin Samui", "userPhoneNumber": "+919126239323", "userProfileImage": UIImage(), "isUserSelected": false]]
    fileprivate var searchActive: Bool = false
    
    fileprivate var selectedContactDetailsData: [[String: Any]] = []
    fileprivate var headerImageCollectionViewSizeOfCell: CGSize = CGSize()
    fileprivate var mainTopCollectionViewHeight: CGFloat = (UIScreen.main.bounds.width * 60) / 100
    fileprivate var rechargeTopImageCollectionViewFlowLayout = UICollectionViewFlowLayout()
    fileprivate var selectedIndexFromCollectionView: IndexPath = IndexPath()
    fileprivate var layOutManagedProperly: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        expandOrCollapseTopCollectionView(isExpand: false, onFirstLoad: true)
        searchBarController.searchBar.returnKeyType = .done
        searchBarController.delegate = self
        searchBarController.searchBar.delegate = self
        searchBarController.hidesNavigationBarDuringPresentation = true
        searchBarController.dimsBackgroundDuringPresentation = false
        searchBarController.searchBar.sizeToFit()
        searchBarController.searchBar.backgroundImage = UIImage()
        searchBarController.searchBar.searchBarStyle = UISearchBarStyle.minimal
        searchBarController.searchBar.placeholder = "Contacts"
        contactDetailsMainTableView.delegate = self
        contactDetailsMainTableView.dataSource = self
        contactDetailsMainTableView.register(UINib(nibName: "ContactDetailsMainTableViewCell", bundle: nil), forCellReuseIdentifier: "contactDetailsMainTableViewCellId")
        contactDetailsMainTableView.register(UINib(nibName: "ContactsTableViewHeaderCell", bundle: nil), forCellReuseIdentifier: "contactsTableViewHeaderCellId")
        favouriteSelectedContactsMainCollectionView.delegate = self
        favouriteSelectedContactsMainCollectionView.dataSource = self
        favouriteSelectedContactsMainCollectionView.register(UINib(nibName: "SelectedContactsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "selectedContactsCollectionViewCellId")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if layOutManagedProperly != true {
            layOutManagedProperly = true
        searchBarController.searchBar.frame = contactSearchMainSuperView.frame
        contactSearchMainSuperView.addSubview(searchBarController.searchBar)
        headerImageCollectionViewSizeOfCell = CGSize(width: 70, height: 110)
        rechargeTopImageCollectionViewFlowLayout.scrollDirection = .horizontal
        favouriteSelectedContactsMainCollectionView.collectionViewLayout = rechargeTopImageCollectionViewFlowLayout
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getAllContactsBtnAction(_ sender: UIButton) {
        ContactFetchingTaskStruct.requestForAccessContacts(onCompletion: { finished in switch finished { //[unwoned self]
        case true:
            debugPrint("Contacts authenticated on this device!!")
            DispatchQueue.main.async(execute: {
                ContactFetchingTaskStruct.fetchContactsFromDevice(onCompletion: { completeFetchedContacts in
                    
                    ContactFetchingTaskStruct.handlePhoneContacts(mainContactsDataFromDevice: completeFetchedContacts, onCompletion: { [unowned self] userDetailsData in
                        if !userDetailsData.isEmpty {
                            self.contactsCompleteDataFromDevice = userDetailsData
                            GenericFunctionRelatedStruct.prepareDataForTableView(rawUnfilteredContacts: self.contactsCompleteDataFromDevice, onFirstLoad: true, onCompletion: {(finished, responseData, finalContactData, firstTimeLoad) in switch finished {
                                
                            case true:
                                debugPrint("Error formatting data for table!")
                                
                            case false:
                                
                                if !finalContactData.isEmpty && firstTimeLoad == true{
                                    self.contactsCompleteDataFromDevice = finalContactData
                                }
                                
                                self.searchedContactsData.removeAll()
                                self.mainContactsTableViewData = responseData
                                //                                self.contactDetailsMainTableView.reloadData()
                                self.flipViewScreen(firstViewObject: self.authenticationMainSuperView, secondViewObject: self.contactDetailsMainSuperView, isForward: true, timeDuration: 1.0)
                                }
                                
                            })
                            
                        } else {
                            self.contactsCompleteDataFromDevice.removeAll()
                        }
                    })
                    
                })
                
            })
            
            
        case false:
            debugPrint("Error authenticating contact on this device! Please allow this app on settings")
            }
        })
        
        
    }
    
    fileprivate func animateTableOfInviteAndEarn(tableViewObject tableView: UITableView) {
        tableView.reloadData()
        let allVisibleCells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        var indexValue = 0
        
        for eachCell in allVisibleCells {
            let cellObject: UITableViewCell = eachCell as UITableViewCell
            cellObject.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        for eachCell in allVisibleCells {
            let cellObject: UITableViewCell = eachCell as UITableViewCell
            UIView.animate(withDuration: 0.3, delay: 0.05 * Double(indexValue), usingSpringWithDamping: 0.9, initialSpringVelocity: 0.3, options: [], animations: {
                cellObject.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: nil)
            indexValue += 1
        }
    }
    
    
    fileprivate func calculateSpecificRowAndScrollOnSelection(selectedIndex indexPath: IndexPath){
        let selectedDataValue = self.selectedContactDetailsData[indexPath.row]
        if let selctedSectionIndexCheck = selectedDataValue["sectionHeaderIndex"] as? Int,
            let selectedCellIndexCheck = selectedDataValue["sectionCellIndex"] as? Int {
            let indexPathToScroll = IndexPath(row: selectedCellIndexCheck, section: selctedSectionIndexCheck)
            
            contactDetailsMainTableView.scrollToRow(at: indexPathToScroll, at: UITableViewScrollPosition.none, animated: true)
        }
    }
    
    fileprivate func expandOrCollapseTopCollectionView(isExpand expandBool: Bool, onFirstLoad isFirstLoad: Bool){
        switch expandBool {
        case true: //Expand the collection to show
            if self.contactDetailsTopFavouriteSuperViewHeight.constant < 100 {
                UIView.animate(withDuration: 0.3, delay: 0.2, options: [.curveEaseOut], animations: {
                    self.contactDetailsTopFavouriteSuperViewHeight.constant = 110.0
                    if isFirstLoad == false {
                        self.view.layoutIfNeeded()
                    }
                    
                }, completion: { finished in
                    if isFirstLoad == true {
                        self.view.layoutIfNeeded()
                    }
                    self.favouriteSelectedContactsMainCollectionView.reloadData()
                    
                })
            }else{
                self.favouriteSelectedContactsMainCollectionView.reloadData()
            }
        case false: //Collapse the collection to hide
            if self.contactDetailsTopFavouriteSuperViewHeight.constant != 0 {
                UIView.animate(withDuration: 0.3, delay: 0.2, options: [.curveEaseOut], animations: {
                    self.contactDetailsTopFavouriteSuperViewHeight.constant = 0.0
                    
                    if isFirstLoad == false {
                        self.view.layoutIfNeeded()
                    }
                }, completion: { finished in
                    if isFirstLoad == true {
                        self.view.layoutIfNeeded()
                    }
                })
            }
        }
    }
    
    
    fileprivate func selectDataAndRefresh(whichIndex indexPath: IndexPath){
        DispatchQueue.main.async(execute: {
            switch self.searchActive {
            case true:
                
                if let mainContactsTableViewDataCheck = self.mainContactsTableViewData,
                    !mainContactsTableViewDataCheck.isEmpty{
                    if let cellSelectionCheck = mainContactsTableViewDataCheck[indexPath.row]["isUserSelected"] as? Bool,
                        cellSelectionCheck == true{
                        self.mainContactsTableViewData?[indexPath.row].updateValue(false, forKey: "isUserSelected")
                        
                        if let cellSelectionIndexCheck = mainContactsTableViewDataCheck[indexPath.row]["selectionIndex"] as? Int {
                            self.contactsCompleteDataFromDevice[cellSelectionIndexCheck].updateValue(false, forKey: "isUserSelected")
                            
                            for (index, object) in self.selectedContactDetailsData.enumerated() {
                                if let selectionIndexCheck = object["selectionIndex"] as? Int,
                                    selectionIndexCheck == cellSelectionIndexCheck{
                                    self.selectedContactDetailsData.remove(at: index)
                                    break
                                } else {
                                    continue
                                }
                            }
                        }
                    } else {
                        self.mainContactsTableViewData?[indexPath.row].updateValue(true, forKey: "isUserSelected")
                        
                        if let cellSelectionIndexCheck = mainContactsTableViewDataCheck[indexPath.row]["selectionIndex"] as? Int {
                            self.selectedContactDetailsData.append(self.contactsCompleteDataFromDevice[cellSelectionIndexCheck])
                            
                            self.contactsCompleteDataFromDevice[cellSelectionIndexCheck].updateValue(true, forKey: "isUserSelected")
                        }
                        
                    }
                }
                
                
                
            case false:
                
                
                if let mainContactsTableViewDataCheck = self.mainContactsTableViewData?[indexPath.section]["sectionContactData"] as? [[String: Any]],
                    !mainContactsTableViewDataCheck.isEmpty {
                    var mainContactsTableViewDataToUpdate = mainContactsTableViewDataCheck
                    if let cellSelectionCheck = mainContactsTableViewDataCheck[indexPath.row]["isUserSelected"] as? Bool,
                        cellSelectionCheck == true{
                        mainContactsTableViewDataToUpdate[indexPath.row].updateValue(false, forKey: "isUserSelected")
                        
                        if let cellSelectionIndexCheck = mainContactsTableViewDataCheck[indexPath.row]["selectionIndex"] as? Int {
                            
                            self.contactsCompleteDataFromDevice[cellSelectionIndexCheck].updateValue(false, forKey: "isUserSelected")
                            
                            for (index, object) in self.selectedContactDetailsData.enumerated() {
                                debugPrint(object)
                                if let selectionIndexCheck = object["selectionIndex"] as? Int,
                                    selectionIndexCheck == cellSelectionIndexCheck{
                                    self.selectedContactDetailsData.remove(at: index)
                                    break
                                } else {
                                    continue
                                }
                            }
                            
                        }
                        
                        
                        
                    } else {
                        mainContactsTableViewDataToUpdate[indexPath.row].updateValue(true, forKey: "isUserSelected")
                        
                        if let cellSelectionIndexCheck = mainContactsTableViewDataCheck[indexPath.row]["selectionIndex"] as? Int {
                            
                            self.selectedContactDetailsData.append(self.contactsCompleteDataFromDevice[cellSelectionIndexCheck])
                            
                            self.contactsCompleteDataFromDevice[cellSelectionIndexCheck].updateValue(true, forKey: "isUserSelected")
                        }
                        
                    }
                    
                    self.mainContactsTableViewData?[indexPath.section].updateValue(mainContactsTableViewDataToUpdate, forKey: "sectionContactData")
                    
                }
            }
            
            if !self.selectedContactDetailsData.isEmpty {
                self.expandOrCollapseTopCollectionView(isExpand: true, onFirstLoad: false)
            } else {
                self.expandOrCollapseTopCollectionView(isExpand: false, onFirstLoad: false)
            }
            
            self.contactDetailsMainTableView.reloadData()
        })
    }
    
    
    fileprivate func flipViewScreen(firstViewObject firstView: UIView, secondViewObject secondView: UIView, isForward flipForward: Bool, timeDuration flipDuration: TimeInterval){
        switch flipForward {
        case true:
            let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
            UIView.transition(with: firstView, duration: flipDuration, options: transitionOptions, animations: {
                firstView.isHidden = true
            }, completion: { finished in
                self.animateTableOfInviteAndEarn(tableViewObject: self.contactDetailsMainTableView)
            })
            
            UIView.transition(with: secondView, duration: flipDuration, options: transitionOptions, animations: {
                secondView.isHidden = false
            }, completion: nil)
        case false:
            let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromLeft, .showHideTransitionViews]
            UIView.transition(with: secondView, duration: flipDuration, options: transitionOptions, animations: {
                secondView.isHidden = true
            }, completion: nil)
            
            UIView.transition(with: firstView, duration: flipDuration, options: transitionOptions, animations: {
                firstView.isHidden = false
            }, completion: nil)
        }
    }
    
    
    @objc fileprivate func filterContentForSearchText(textToSearch searchText: String) {
        mainContactsTableViewData?.removeAll()
        DispatchQueue.main.async(execute: {
            
            
            self.mainContactsTableViewData = self.contactsCompleteDataFromDevice.filter({contact in
                if let acceptedName = (contact["userName"] as? String)?.lowercased().contains(searchText.lowercased()) {
                    switch acceptedName {
                    case true:
                        return acceptedName
                    case false:
                        if let acceptedNumber = (contact["userPhoneNumber"] as? String)?.lowercased().contains(searchText.lowercased()) {
                            return acceptedNumber
                        } else {
                            return false
                        }
                    }
                } else {
                    if let acceptedName = (contact["userPhoneNumber"] as? String)?.lowercased().contains(searchText.lowercased()) {
                        return acceptedName
                    } else {
                        return false
                    }
                }
            })
            
            if let mainContactsCellDataCheck = self.mainContactsTableViewData,
                mainContactsCellDataCheck.isEmpty{
                let noResultsFoundData: [[String : Any]] = [["userName": "No result found!", "isUserSelected": false]]
                self.mainContactsTableViewData = noResultsFoundData
            }
            self.contactDetailsMainTableView.reloadData()
        })
    }
}

extension ContactsMainViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if(tableView.responds(to: #selector(setter: UITableViewCell.separatorInset))) {
            tableView.separatorInset = UIEdgeInsets.zero
        }
        
        if(tableView.responds(to: #selector(setter: UIView.layoutMargins))) {
            tableView.layoutMargins = UIEdgeInsets.zero
        }
        
        if(cell.responds(to: #selector(setter: UIView.layoutMargins))) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath),
            cell.isSelected == true{
            selectDataAndRefresh(whichIndex: indexPath)
        }
    }
}

extension ContactsMainViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchActive == false,
            let mainContactsTableViewDataCheck = mainContactsTableViewData{
            return mainContactsTableViewDataCheck.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive == false,
            let mainContactsTableViewDataCheck = mainContactsTableViewData?[section]["sectionContactData"] as? [[String: Any]],
            !mainContactsTableViewDataCheck.isEmpty{
            return mainContactsTableViewDataCheck.count
        } else if searchActive == true,
            let mainContactsTableViewDataCheck = mainContactsTableViewData{
            return mainContactsTableViewDataCheck.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "contactDetailsMainTableViewCellId", for: indexPath) as? ContactDetailsMainTableViewCell{
            var mainContactsTableData: [[String: Any]] = []
            
            switch searchActive {
            case true:
                if let mainContactsTableViewDataCheck = mainContactsTableViewData,
                    !mainContactsTableViewDataCheck.isEmpty{
                    mainContactsTableData = mainContactsTableViewDataCheck
                } else {
                    mainContactsTableData.removeAll()
                }
                
                
            case false:
                if let mainContactsTableViewDataCheck = mainContactsTableViewData?[indexPath.section]["sectionContactData"] as? [[String: Any]],
                    !mainContactsTableViewDataCheck.isEmpty{
                    mainContactsTableData = mainContactsTableViewDataCheck
                } else {
                    mainContactsTableData.removeAll()
                }
            }
            
            if !mainContactsTableData.isEmpty {
                if let cellSelectionCheck = mainContactsTableData[indexPath.row]["isUserSelected"] as? Bool,
                    cellSelectionCheck == true{
                    cell.userContactDetailsCellSelectedSuperView.backgroundColor = UIColor.blue
                } else {
                    cell.userContactDetailsCellSelectedSuperView.backgroundColor = UIColor.clear
                }
                
                
                if let userNameCheck = mainContactsTableData[indexPath.row]["userName"] as? String,
                    !userNameCheck.isEmpty {
                    cell.userContactDetailsNameLbl.text = userNameCheck
                    
                } else {
                    cell.userContactDetailsNameLbl.text = "No User Name Found!"
                    
                }
                
                if let userPhoneNumberCheck = mainContactsTableData[indexPath.row]["userPhoneNumber"] as? String,
                    !userPhoneNumberCheck.isEmpty {
                    cell.userContactDetailsNumberLbl.text = userPhoneNumberCheck
                    
                } else {
                    cell.userContactDetailsNumberLbl.text = "No Phone Number Found!"
                }
                
                
                if let userProfileImageCheck = mainContactsTableData[indexPath.row]["userProfileImage"] as? Data{
                    cell.userContactDetailsMainProfileImageView.backgroundColor = UIColor.clear
                    let userProfileImage = UIImage(data: userProfileImageCheck)
                    cell.userContactDetailsMainProfileImageView.kf.setImage(with: nil, placeholder: userProfileImage, options: [.transition(ImageTransition.fade(0.5))], progressBlock: nil, completionHandler: nil)
                    
                } else {
                    cell.userContactDetailsMainProfileImageView.image = nil
                    cell.userContactDetailsMainProfileImageView.backgroundColor = UIColor.brown
                }
                
                
                
                
            } else {
                cell.userContactDetailsMainProfileImageView.backgroundColor = UIColor.clear
                cell.userContactDetailsMainProfileImageView.image = nil
                cell.userContactDetailsNumberLbl.text = nil
                cell.userContactDetailsNameLbl.text = nil
                cell.userContactDetailsCellSelectedSuperView.backgroundColor = UIColor.clear
            }
            
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let headerView = tableView.dequeueReusableCell(withIdentifier: "contactsTableViewHeaderCellId") as? ContactsTableViewHeaderCell{
            headerView.sectionMainSuperView.backgroundColor = UIColor.white
            switch searchActive {
                
            case true:
                headerView.sectionMainHeaderLbl.text = nil
                
            case false:
                if let sectionHeaderCheck = mainContactsTableViewData?[section]["sectionHeader"] as? String,
                    !sectionHeaderCheck.isEmpty{
//                    debugPrint(sectionHeaderCheck)
                    headerView.sectionMainHeaderLbl.text = sectionHeaderCheck
                } else {
                    headerView.sectionMainHeaderLbl.text = nil
                }
            }
            return headerView
        } else {
            return UIView()
        }
    }
    
}

extension ContactsMainViewController: UISearchBarDelegate, UISearchControllerDelegate { //UISearchResultsUpdating
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if let searchText = searchBarController.searchBar.text,
            searchText.isEmpty {
            searchActive = false
        } else {
            searchActive = true
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBarController.searchBar.text,
            searchText.isEmpty {
            searchActive = false
            
            DispatchQueue.main.async(execute: {
                GenericFunctionRelatedStruct.prepareDataForTableView(rawUnfilteredContacts: self.contactsCompleteDataFromDevice, onFirstLoad: false, onCompletion: {(finished, responseData, finalContactData, _) in switch finished {
                    
                case true:
                    debugPrint("Error formatting data for table!")
                    
                case false:
                    self.mainContactsTableViewData = responseData
                    self.contactDetailsMainTableView.reloadData()
                    }
                })
            })
        } else {
            searchActive = true
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        DispatchQueue.main.async(execute: {
            GenericFunctionRelatedStruct.prepareDataForTableView(rawUnfilteredContacts: self.contactsCompleteDataFromDevice, onFirstLoad: false, onCompletion: {(finished, responseData, finalContactData, _) in switch finished {
                
            case true:
                debugPrint("Error formatting data for table!")
                
            case false:
                self.mainContactsTableViewData = responseData
                self.contactDetailsMainTableView.reloadData()
                }
            })
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        debugPrint(searchText)
        searchActive = true
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(filterContentForSearchText), object: searchBar)
        self.perform(#selector(filterContentForSearchText), with: searchText, afterDelay: 0.4)
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
        DispatchQueue.main.async(execute: {
            
            
            if self.selectedContactsClicked == true{
                
                GenericFunctionRelatedStruct.prepareDataForTableView(rawUnfilteredContacts: self.contactsCompleteDataFromDevice, onFirstLoad: false, onCompletion: {(finished, responseData, finalContactData, _) in switch finished {
                    
                case true:
                    debugPrint("Error formatting data for table!")
                    
                case false:
                    self.mainContactsTableViewData = responseData
                    self.contactDetailsMainTableView.reloadData()
                    self.calculateSpecificRowAndScrollOnSelection(selectedIndex: self.selectedIndexFromCollectionView)
                    }
                })
            } else {
                
            }
        })
        
    }
}

extension ContactsMainViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return headerImageCollectionViewSizeOfCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath),
            cell.isSelected == true{
            selectedIndexFromCollectionView = indexPath
            if (searchBarController.isActive == true){
                searchBarController.isActive = false
                selectedContactsClicked = true
            } else {
                selectedContactsClicked = false
                calculateSpecificRowAndScrollOnSelection(selectedIndex: selectedIndexFromCollectionView)
            }
            
        }
    }
    
    
    
}



extension ContactsMainViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedContactDetailsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cellOfCollection = collectionView.dequeueReusableCell(withReuseIdentifier: "selectedContactsCollectionViewCellId", for: indexPath) as? SelectedContactsCollectionViewCell{
            cellOfCollection.backgroundColor = UIColor.clear
            cellOfCollection.selectedContactsNameLbl.textColor = UIColor.black
            if let userNameCheck = selectedContactDetailsData[indexPath.row]["userName"] as? String,
                !userNameCheck.isEmpty,
                let userFirstNameCheck = userNameCheck.getWordOfAString(){
//                debugPrint(userNameCheck)
                cellOfCollection.selectedContactsNameLbl.text = userFirstNameCheck
            } else {
                cellOfCollection.selectedContactsNameLbl.text = nil
            }
            
            if let userProfileImageCheck = selectedContactDetailsData[indexPath.row]["userProfileImage"] as? Data{
                cellOfCollection.selectedContactsMainImageViewSuperView.backgroundColor = UIColor.clear
                let userProfileImage = UIImage(data: userProfileImageCheck)
                cellOfCollection.selectedContactsMainImageView.kf.setImage(with: nil, placeholder: userProfileImage, options: [.transition(ImageTransition.fade(0.5))], progressBlock: nil, completionHandler: nil)
                
            } else {
                cellOfCollection.selectedContactsMainImageView.image = nil
                cellOfCollection.selectedContactsMainImageViewSuperView.backgroundColor = UIColor.lightGray
            }
            
            
            return cellOfCollection
        }else{
            return UICollectionViewCell()
        }
    }
}
