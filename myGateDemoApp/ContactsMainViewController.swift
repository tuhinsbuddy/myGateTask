//
//  ContactsMainViewController.swift
//  myGateDemoApp
//
//  Created by Tuhin Samui on 16/07/17.
//  Copyright © 2017 Tuhin Samui. All rights reserved.
//

import UIKit

class ContactsMainViewController: UIViewController {
    
    @IBOutlet weak var favouriteSelectedContactsMainCollectionView: UICollectionView!
    @IBOutlet weak var contactSearchMainSuperView: UIView!
    @IBOutlet weak var contactDetailsMainStackView: UIStackView!
    @IBOutlet weak var contactDetailsTopFavouriteSuperView: UIView!
    @IBOutlet weak var contactDetailsMainTableViewSuperView: UIView!
    @IBOutlet weak var contactDetailsMainTableView: UITableView!
    @IBOutlet weak var getAllContactsBtn: UIButton!
    @IBOutlet weak var authenticationMainSuperView: UIView!
    @IBOutlet weak var contactDetailsMainSuperView: UIView!
    
    fileprivate let searchBarController = UISearchController(searchResultsController: nil)
    fileprivate var mainContactsTableViewData: [[String: Any]]? = []
    fileprivate var contactsCompleteDataFromDevice: [[String: Any]] = []
    fileprivate var searchedText: String = ""

    fileprivate var selectedContactDetailsData: [[String: Any]] = [["userName": "Tuhin", "userImage": "profileImage1"], ["userName": "Tuhin", "userImage": "profileImage2"], ["userName": "Tuhin", "userImage": "profileImage3"], ["userName": "Tuhin", "userImage": "profileImage4"], ["userName": "Tuhin", "userImage": "profileImage1"], ["userName": "Tuhin", "userImage": "profileImage1"], ["userName": "Tuhin", "userImage": "profileImage1"], ["userName": "Tuhin", "userImage": "profileImage1"], ["userName": "Tuhin", "userImage": "profileImage1"], ["userName": "Tuhin", "userImage": "profileImage1"]]
    fileprivate var headerImageCollectionViewSizeOfCell: CGSize = CGSize()
    fileprivate var mainTopCollectionViewHeight: CGFloat = (UIScreen.main.bounds.width * 60) / 100
    fileprivate var rechargeTopImageCollectionViewFlowLayout = UICollectionViewFlowLayout()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

//        for _ in 0...10000 {
//            let dataToAppend: [String: Any] = ["nameString": "showLoader", "selected": false]
//            mainContactsCellData?.append(dataToAppend)
//        }
        
//        debugPrint(mainContactsCellData?.count)
        
        searchBarController.searchBar.returnKeyType = .done
        searchBarController.delegate = self
        searchBarController.searchBar.delegate = self
        searchBarController.hidesNavigationBarDuringPresentation = true
        searchBarController.searchResultsUpdater = self
        searchBarController.dimsBackgroundDuringPresentation = false
        searchBarController.searchBar.sizeToFit()
        searchBarController.searchBar.backgroundImage = UIImage()
        searchBarController.searchBar.searchBarStyle = UISearchBarStyle.minimal
        searchBarController.searchBar.placeholder = "Contacts"
        
        contactDetailsMainTableView.delegate = self
        contactDetailsMainTableView.dataSource = self
        contactDetailsMainTableView.register(UINib(nibName: "ContactDetailsMainTableViewCell", bundle: nil), forCellReuseIdentifier: "contactDetailsMainTableViewCellId")
        
        favouriteSelectedContactsMainCollectionView.delegate = self
        favouriteSelectedContactsMainCollectionView.dataSource = self
        favouriteSelectedContactsMainCollectionView.register(UINib(nibName: "SelectedContactsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "selectedContactsCollectionViewCellId")

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBarController.searchBar.frame = contactSearchMainSuperView.frame
        contactSearchMainSuperView.addSubview(searchBarController.searchBar)
        headerImageCollectionViewSizeOfCell = CGSize(width: 70, height: 110)
        rechargeTopImageCollectionViewFlowLayout.scrollDirection = .horizontal
        favouriteSelectedContactsMainCollectionView.setCollectionViewLayout(rechargeTopImageCollectionViewFlowLayout, animated: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func getAllContactsBtnAction(_ sender: UIButton) {
        
        
        
    }
    
    
    
    
    @objc fileprivate func filterContentForSearchText(textToSearch searchText: String) {
        debugPrint(searchText)
        if let mainContactsCellDataCheck = mainContactsTableViewData,
            !mainContactsCellDataCheck.isEmpty{
            mainContactsTableViewData?.removeAll()
        }
        
            mainContactsTableViewData = contactsCompleteDataFromDevice.filter({contact in
                if let acceptedName = (contact["nameString"] as? String)?.lowercased().contains(searchText.lowercased()) {
                    return acceptedName
                } else {
                    return false
                }
            })
        
        if let mainContactsCellDataCheck = mainContactsTableViewData,
            mainContactsCellDataCheck.isEmpty{
            let noResultsFoundData: [[String : Any]] = [["nameString": "No result found!", "selected": false]]
            mainContactsTableViewData = noResultsFoundData
        }
        
        debugPrint(mainContactsTableViewData?.count)
        
        contactDetailsMainTableView.reloadData()
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
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            if let cell = tableView.cellForRow(at: indexPath),
                cell.isSelected == true{
                
                UIView.animate(withDuration: 0.3, animations: {
//                    cell.contentView.backgroundColor = ColorClass.singleTonForColorClass.slicePayButtonTitleColor.withAlphaComponent(0.5)
                })
            }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
            if let cell = tableView.cellForRow(at: indexPath),
                cell.isSelected == false{
                UIView.animate(withDuration: 0.2, animations: {
                    cell.contentView.backgroundColor = UIColor.white
                })
            }
       
    }
}

extension ContactsMainViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let mainContactsTableViewDataCheck = mainContactsTableViewData {
            return mainContactsTableViewDataCheck.count
        } else {
           return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "contactDetailsMainTableViewCellId", for: indexPath) as? ContactDetailsMainTableViewCell{
                
                return cell
            }else{
                return UITableViewCell()
            }
    }
}

extension ContactsMainViewController: UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if let mainContactsCellDataCheck = mainContactsTableViewData,
            !mainContactsCellDataCheck.isEmpty{
            mainContactsTableViewData?.removeAll()
        }
        contactDetailsMainTableView.reloadData()
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
//        if let searchText = searchBarController.searchBar.text,
//            !searchText.isEmpty {
////            debugPrint("\(searchText)")
//            
//            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(filterContentForSearchText), object: searchText)
//            
//            self.perform(#selector(filterContentForSearchText), with: searchText, afterDelay: 0.4)
//            
//        } else {
//            mainContactsTableViewData = contactsCompleteDataFromDevice
//            contactDetailsMainTableView.reloadData()
//        }
//        
//        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
//            debugPrint("\(searchText)")
            searchedText = searchText
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(filterContentForSearchText), object: searchBar)
            
            self.perform(#selector(filterContentForSearchText), with: searchedText, afterDelay: 1.0)
            
        } else {
            mainContactsTableViewData = contactsCompleteDataFromDevice
            contactDetailsMainTableView.reloadData()
        }
}
}

//extension ContactsMainViewController: UISearchControllerDelegate, UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        if let searchText = searchBarController.searchBar.text,
//            !searchText.isEmpty {
//                debugPrint("\(searchText)")
////                filterContentForSearchText(textToSearch: searchText)
//            }
//    }
//}

extension ContactsMainViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return headerImageCollectionViewSizeOfCell
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
            cellOfCollection.selectedContactsMainImageViewSuperView.backgroundColor = UIColor.red
            cellOfCollection.selectedContactsNameLbl.text = "Tuhin"
            cellOfCollection.selectedContactsNameLbl.textColor = UIColor.black

            return cellOfCollection
        }else{
            return UICollectionViewCell()
        }
    }
}
