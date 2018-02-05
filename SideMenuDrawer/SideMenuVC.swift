//
//  SideMenuVC.swift
//  SideMenuDrawer
//
//  Created by IosDeveloper on 31/01/18.
//  Copyright © 2018 iOSDeveloper. All rights reserved.
//

import UIKit

class SideMenuVC: UIViewController {

    ///TableView Outlet
    @IBOutlet weak var sideMenuTable: UITableView!
    
    ///Array Declarations
    let sideMenuArray = ["Index 0","Index 1","Index 2","Index 3"]
    
    //MARK: Did Load
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ///Set Delegates For TableView
        sideMenuTable.delegate = self
        sideMenuTable.dataSource = self
        
        ///Set Footer View as Empty
        sideMenuTable.tableFooterView = UIView()
    }

}

//MARK:- TableView Delegates
extension SideMenuVC : UITableViewDelegate, UITableViewDataSource
{
    //MARK: Set Number of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        ///Return Count in Array
        return sideMenuArray.count
    }
    
    //MARK: Set Cell Data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        ///Initiate Cell
        let cell = self.sideMenuTable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        ///Set Values
        cell.textLabel?.text = sideMenuArray[indexPath.row]
        
        ///Return Cell View
        return cell
    }
    
    //MARK: Selection Method
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        ///Get index Selected
        switch indexPath.row
        {
        //Navigate To Main Recording Screen
        case 0:
            Manager.sideIndex = 0
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideMenu"), object: nil)
            break
        //Navigate to Recording List Screen
        case 1:
            Manager.sideIndex = 1
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideMenu"), object: nil)
            break
        //Show Previous Recordings done
        case 2:
            Manager.sideIndex = 2
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideMenu"), object: nil)
            break
        //Logout
        case 3:
            Manager.sideIndex = 3
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideMenu"), object: nil)
            break
        default:
            print("No case Exists")
        }
    }
    
    //MARK: Set Height For row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    
}
