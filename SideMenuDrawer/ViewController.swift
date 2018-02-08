//
//  ViewController.swift
//  SideMenuDrawer
//
//  Created by IosDeveloper on 31/01/18.
//  Copyright © 2018 iOSDeveloper. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

    ///BaseView i.e Side Menu View
    var baseView = UIView()
    
    ///Blur View
    var blurView = UIVisualEffectView()
    
    ///Maximum y that let Side Menu View to move to maximum position
    var maximum_x = CGFloat()
    
    //MARK: Side Menu Object
    private lazy var sideMenuVCObject: SideMenuVC =
    {
        // Instantiate View Controller
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        
        // Add View Controller as Child View Controller
        self.addChildViewController(viewController)
        return viewController
    }()
    
    //MARK: Add Subview in Side Menu view
    private func add(asChildViewController viewController: UIViewController, baseView: UIView)
    {
        // Configure Child View
        viewController.view.frame = CGRect(x: 0, y: 0, width: baseView.frame.size.width, height: baseView.frame.size.height)
        
        // Add Child View Controller
        addChildViewController(viewController)
        viewController.view.translatesAutoresizingMaskIntoConstraints = true
        
        // Add Child View as Subview
        baseView.addSubview(viewController.view)
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    
    //MARK: Remove Subview from Side Menu view
    private func remove(asChildViewController viewController: UIViewController, baseView: UIView)
    {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        baseView.willRemoveSubview(viewController.view)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }  
}

//MARK:- Button Actions
extension ViewController
{
    //MARK: Menu Button
    @IBAction func showMenuBtnAction(_ sender: Any)
    {
        /// Add Side Menu Subview
        AddPanGesture()
    }
}

//MARK:- Custom Functions
extension ViewController
{
    //MARK: baseView Frame For SideMenu
    func AddSideMenuBaseView() -> UIView
    {
        baseView.backgroundColor = UIColor.clear
        baseView.frame = CGRect(x: 0, y: 0 , width: self.view.frame.size.width*0.7, height: self.view.frame.size.height)
        self.maximum_x = baseView.frame.maxX
        return baseView
    }
    
    //MARK: Add panGesture in BaseView
    func AddPanGesture()
    {
        //Observer to update Button Text to record
        NotificationCenter.default.addObserver(self, selector: #selector(performSelectedOperationFromSideMenu), name: NSNotification.Name(rawValue: "hideMenu"), object: nil)
        let gesture : UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action:#selector(ViewController.handlePanGesture(panGesture:)))
        let gesture1 : UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action:#selector(ViewController.handlePanGestureOfBlurView(panGesture:)))
        let vv = AddSideMenuBaseView()
        let bv = addBlurEffectView()
        self.add(asChildViewController: sideMenuVCObject, baseView: vv)
        vv.addGestureRecognizer(gesture)
        bv.addGestureRecognizer(gesture1)
        self.view.addSubview(vv)
        self.view.addSubview(bv)
        view.bringSubview(toFront: vv)
    }
    
    
    //MARK: Add Blur Effect
    func addBlurEffectView() -> UIVisualEffectView
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurView
    }
    
    //MARK: Pan gesture handler for Blur View
    @objc func handlePanGestureOfBlurView(panGesture: UIPanGestureRecognizer)
    {
        ///In this pan is added to Blu View
        ///We will only Modify BaseView as its main View
        ///Get the changes
        let translation = panGesture.translation(in: self.view)

        ///Make View move to left side of Frame
        if CGFloat(round(Double((panGesture.view?.frame.origin.x)!))) <= 0
        {
            self.baseView.center = CGPoint(x: self.baseView.center.x + translation.x, y: self.baseView.center.y)
            panGesture.setTranslation(CGPoint.zero, in: self.view)
        }
        
        ///Do not let View go beyond origin as 0
        if CGFloat(round(Double((self.baseView.frame.origin.x)))) > 0
        {
            panGesture.view?.frame.origin.x = 0
            self.baseView.frame.origin.x = 0
            panGesture.setTranslation(CGPoint.zero, in: self.view)
        }
        
        switch panGesture.state {
        case .changed:
            self.setAlphaOfBlurView(origin: (self.baseView.frame.maxX))
            break
        case .ended:
            if CGFloat(round(Double((self.baseView.frame.maxX)))) >= self.view.frame.size.width*0.35
            {
                UIView.animate(withDuration: 0.7, animations: {
                    self.baseView.frame.origin.x = 0
                    panGesture.setTranslation(CGPoint.zero, in: self.view)
                })
            }
            else
            {
                UIView.animate(withDuration: 0.4, animations: {
                    self.baseView.frame.origin.x -= self.maximum_x
                    panGesture.setTranslation(CGPoint.zero, in: self.view)
                }, completion: { (success) in
                    if (success)
                    {
                        self.remove(asChildViewController: self.sideMenuVCObject, baseView: self.baseView)
                        self.baseView.removeFromSuperview()
                        self.blurView.removeFromSuperview()
                        
                        //Remove Notification observer
                        NotificationCenter.default.removeObserver(self,name: NSNotification.Name(rawValue: "hideMenu"),object: nil)
                    }
                })
            }
            break
        default:
            print("Default Case")
        }
    }
    
    //MARK: Pan gesture Handler
    @objc func handlePanGesture(panGesture: UIPanGestureRecognizer)
    {
        ///Get the changes
        let translation = panGesture.translation(in: self.view)
        
        ///Make View move to left side of Frame
        if CGFloat(round(Double((panGesture.view?.frame.origin.x)!))) <= 0
        {
            panGesture.view!.center = CGPoint(x: panGesture.view!.center.x + translation.x, y: panGesture.view!.center.y)
            panGesture.setTranslation(CGPoint.zero, in: self.view)
        }
        
        ///Do not let View go beyond origin as 0
        if CGFloat(round(Double((panGesture.view?.frame.origin.x)!))) > 0
        {
            panGesture.view?.frame.origin.x = 0
            panGesture.setTranslation(CGPoint.zero, in: self.view)
        }
        
        ///States When Dragging
        switch panGesture.state
        {
        case .changed:
            self.setAlphaOfBlurView(origin: (panGesture.view?.frame.maxX)!)
            
        case .ended:
            if CGFloat(round(Double((panGesture.view?.frame.maxX)!))) >= self.view.frame.size.width*0.35
            {
                UIView.animate(withDuration: 0.7, animations: {
                    panGesture.view?.frame.origin.x = 0
                    panGesture.setTranslation(CGPoint.zero, in: self.view)
                })
            }
            else
            {
                UIView.animate(withDuration: 0.4, animations: {
                    panGesture.view?.frame.origin.x -= self.maximum_x
                    panGesture.setTranslation(CGPoint.zero, in: self.view)
                }, completion: { (success) in
                    if (success)
                    {
                        self.remove(asChildViewController: self.sideMenuVCObject, baseView: self.baseView)
                        self.baseView.removeFromSuperview()
                        self.blurView.removeFromSuperview()
                        
                        //Remove Notification observer
                        NotificationCenter.default.removeObserver(self,name: NSNotification.Name(rawValue: "hideMenu"),object: nil)
                    }
                })
            }
            break
        default:
            print("Default Case")
        }
    }
    
    //MARK: Navigate to screens from Side Menu
    @objc func performSelectedOperationFromSideMenu()
    {
        switch Manager.sideIndex
        {
        case 0:
            showToast(message: "Clicked Index : \(0)")
            self.hideSideMenu()
            break
        case 1:
            showToast(message: "Clicked Index : \(1)")
            self.hideSideMenu()
            break
        case 2:
            showToast(message: "Clicked Index : \(2)")
            self.hideSideMenu()
            break
        case 3:
            showToast(message: "Clicked Index : \(3)")
            self.hideSideMenu()
            break
        default:
            print("Default Case")
        }
    }
    
    //MARK: Set Blur Effect Alpha
    func setAlphaOfBlurView(origin : CGFloat)
    {
        if origin <= maximum_x
        {
            blurView.alpha = 0.8
        }
        else if origin > self.view.frame.size.width*0.5
        {
            blurView.alpha = 0.5
        }
        else if origin > self.view.frame.size.width*0.3
        {
            blurView.alpha = 0.3
        }
        ///Reload view
        blurView.setNeedsDisplay()
    }
    
    //MARK: Hide SLiding Menu
    func hideSideMenu()
    {
        UIView.animate(withDuration: 0.7, animations:
            {
                self.baseView.frame.origin.x -= self.maximum_x
        }, completion: { (success) in
            self.remove(asChildViewController: self.sideMenuVCObject, baseView: self.baseView)
            self.baseView.removeFromSuperview()
            self.blurView.removeFromSuperview()
        })
        
        //Remove Notification observer
        NotificationCenter.default.removeObserver(self,name: NSNotification.Name(rawValue: "hideMenu"),object: nil)
    }
}

