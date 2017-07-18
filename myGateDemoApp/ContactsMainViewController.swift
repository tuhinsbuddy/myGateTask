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
    fileprivate var mainContactsCellData: [[String: Any]]? = [[:]]
    fileprivate var selectedContactDetailsData: [[String: Any]] = [["userName": "Tuhin", "userImage": "profileImage1"], ["userName": "Tuhin", "userImage": "profileImage2"], ["userName": "Tuhin", "userImage": "profileImage3"], ["userName": "Tuhin", "userImage": "profileImage4"], ["userName": "Tuhin", "userImage": "profileImage1"], ["userName": "Tuhin", "userImage": "profileImage1"], ["userName": "Tuhin", "userImage": "profileImage1"], ["userName": "Tuhin", "userImage": "profileImage1"], ["userName": "Tuhin", "userImage": "profileImage1"], ["userName": "Tuhin", "userImage": "profileImage1"]]
    fileprivate var headerImageCollectionViewSizeOfCell: CGSize = CGSize()
    fileprivate var mainTopCollectionViewHeight: CGFloat = (UIScreen.main.bounds.width * 60) / 100
    fileprivate var rechargeTopImageCollectionViewFlowLayout = UICollectionViewFlowLayout()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        for _ in 0...10000 {
            let dataToAppend: [String: Any] = ["nameString": "showLoader", "selected": false]
            mainContactsCellData?.append(dataToAppend)
        }
        
        debugPrint(mainContactsCellData?.count)
        
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
        headerImageCollectionViewSizeOfCell = CGSize(width: 80, height: 80)
        rechargeTopImageCollectionViewFlowLayout.scrollDirection = .horizontal
        favouriteSelectedContactsMainCollectionView.setCollectionViewLayout(rechargeTopImageCollectionViewFlowLayout, animated: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func getAllContactsBtnAction(_ sender: UIButton) {
        
        
        
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
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "contactDetailsMainTableViewCellId", for: indexPath) as? ContactDetailsMainTableViewCell{
                
                return cell
            }else{
                return UITableViewCell()
            }
    }
}

extension ContactsMainViewController: UISearchBarDelegate {
    
    //    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
    //        searchBarController.searchBar.backgroundImage = UIImage()
    //        searchBarController.searchBar.backgroundColor = UIColor.clearColor()//ColorClass.singleTonForColorClass.slicePayViewControllerColor
    //        searchBarController.searchBar.barTintColor = UIColor.clearColor()//ColorClass.singleTonForColorClass.slicePayViewControllerColor
    //        searchBarController.searchBar.tintColor = ColorClass.singleTonForColorClass.slicePayPrimaryOrangeColor
    //    }
    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        switch currentSelectedIndex {
//        case 0:
//            if mainCellData != nil {
//                var nameStringCheck: String = String()
//                if let nameValueCheck: String = mainCellData?[0]["nameString"] as? String {
//                    nameStringCheck = nameValueCheck
//                }
//                if mainCellData?.count != contactsTable.count || nameStringCheck == "showLoader" || nameStringCheck == "No result found!"{
//                    mainCellData!.removeAll()
//                    mainCellData = contactsTable
//                }
//            }
//        case 1:
//            if mainCellData != nil {
//                var nameStringCheck: String = String()
//                if let nameValueCheck: String = mainCellData?[0]["nameString"] as? String {
//                    nameStringCheck = nameValueCheck
//                }
//                if mainCellData?.count != invitedContacts.count || nameStringCheck == "showLoader" || nameStringCheck == "No result found!"{
//                    mainCellData!.removeAll()
//                    mainCellData = invitedContacts
//                }
//            }
//        case 2:
//            if mainCellData != nil {
//                var nameStringCheck: String = String()
//                if let nameValueCheck: String = mainCellData?[0]["nameString"] as? String {
//                    nameStringCheck = nameValueCheck
//                }
//                if mainCellData?.count != buddies.count || nameStringCheck == "showLoader" || nameStringCheck == "No result found!"{
//                    mainCellData!.removeAll()
//                    mainCellData = buddies
//                }
//            }
//        default:
//            debugPrint("Current Selected Index is not matching inside searchbar cancel delegate \(currentSelectedIndex)")
//        }
//        tableView.reloadData()
//    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
//            reloadTableAsPerTheCurrentSegment()        }
    }
}
}

extension ContactsMainViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchBarController.searchBar.text {
            if !searchText.isEmpty {
                debugPrint("\(searchText)")
//                filterContentForSearchText(searchController.searchBar.text!)
            }
        }
    }
}

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
        return 0
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedContactDetailsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cellOfCollection = collectionView.dequeueReusableCell(withReuseIdentifier: "selectedContactsCollectionViewCellId", for: indexPath) as? SelectedContactsCollectionViewCell{
            cellOfCollection.backgroundColor = UIColor.gray//ColorClass.singleTonForColorClass.slicePayViewControllerColor
            cellOfCollection.selectedContactsNameLbl.text = "Tuhin"
            cellOfCollection.selectedContactsNameLbl.textColor = UIColor.black
//            let whichImageToLoadInCollectionView = collectionViewImageNames[indexPath.item]["nameOfImage"]
//            
//            cellOfCollection.rechargeTopBannerImageView.contentMode = .scaleAspectFill//.scaleToFill
//            
//            StyleAndDesignRelatedFunctionClass.singletonObjectForStyleClass.applyImageToImageView(onWhichImageView: cellOfCollection.rechargeTopBannerImageView, imageName: whichImageToLoadInCollectionView, urlString: nil)
//            
            return cellOfCollection
        }else{
            return UICollectionViewCell()
        }
    }
}
