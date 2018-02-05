# Slide-Menu-Drawer
* Add A Side Menu as Subview in any Controller with some Short required Code
* Used Nptification observers To handle Response
* Pan Gesture To move a View, TableView as Side Menu 

# Side Menu Object 

      private lazy var sideMenuVCObject: SideMenuVC =
    {
        // Instantiate View Controller
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        
        // Add View Controller as Child View Controller
        self.addChildViewController(viewController)
        return viewController
    }()
    
    
 # Adding Object as A Subview 


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
    
# Output ScreenShots

![simulator screen shot - iphone 8 plus - 2018-02-05 at 12 13 45](https://user-images.githubusercontent.com/26831784/35791494-51aeff02-0a6e-11e8-9375-81f45cae5277.png)
