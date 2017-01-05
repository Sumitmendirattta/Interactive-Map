import UIKit
import CoreLocation
import AVFoundation

class ViewController: UIViewController, UIScrollViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {

    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var imageview: UIImageView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    var plotImage: UIImageView? = nil
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set scale value
        self.scrollview.minimumZoomScale = 1.0
        //set minimum and maximum
        self.scrollview.maximumZoomScale = 5.0
        
        //set user interaction enabled to true
        self.imageview.userInteractionEnabled = true
        //set delegate
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        //set image clicked
        imageview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "imageClicked:"))
        //get user location
        getCurrentUserLocation()
    }
    
    func imageClicked(gesture: UIGestureRecognizer){
        //set location
        let location = gesture.locationInView(gesture.view)
        //print location
        print(location)
        //set action value
        let actionType = getActionValue(location.x, y: location.y)
        //print on console
        print(actionType)
        //check condition
        if actionType != "" {
            getBuildingDetails(actionType)
        }else{
            //create alert
            let alert = UIAlertController(title: "Select the right building", message: "No details for this building.", preferredStyle: UIAlertControllerStyle.Alert)
           //set alert
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageview
    }
    
    func getActionValue(x: CGFloat, y: CGFloat) -> String{
        var action = "";
        //set buildings
        if (x>=11.0 && x<=63.0 && y>=222.0 && y<=297.0){
            action = "KING"
        }//set eng building
        else if (x>=144.0 && x<=202.0 && y>=94.0 && y<=190.0){
            action = "ENG"
        }//set action for SPG
        else if (x>=177.0 && x<=243.0 && y>=419.0 && y<=509.0){
         
            action = "SPG"
        }else if (x>=70.0 && x<=107.0 && y>=385.0 && y<=439.0){
            action = "YUH"
        }else if (x>=270.0 && x<=306.0 && y>=148.0 && y<=194.0){
            action = "BBC"
        }else if (x>=174.0 && x<=225.0 && y>=175.0 && y<=230.0){
            action = "SU"
        }
        return action
    }
    
    func getBuildingLocation(actionType: String) -> String{
        var buildingLocation = "";
        //set coordinates location
        if(actionType == "KING"){
            buildingLocation = "37.335455,-121.884565"
        }else if(actionType == "ENG"){
            buildingLocation = "37.337139,-121.881321"
        }else if(actionType == "YUH"){
            buildingLocation = "37.333753,-121.882766"
        }else if(actionType == "SU"){
            buildingLocation = "37.336310,-121.880675"
        }else if(actionType == "BBC"){
            buildingLocation = "37.336496,-121.878341"
        }else if(actionType == "SPG"){
            buildingLocation = "37.333062,-121.880221"
        }
        
        return buildingLocation
    }
    
    func getCurrentUserLocation() -> String{
        var userLocation = ""
        
        let currentLocation = locationManager.location;
        //set latitude and logitude
        var longi = "\(-121.884565)"
        var latti = "\(37.335455)"
        //set current location
        if currentLocation != nil{
            longi = "\(currentLocation!.coordinate.longitude)"
            latti = "\(currentLocation!.coordinate.latitude)"
        }
        //set varriables
        let userLon = Double(longi)
        //print variables
        print(userLon)
        let userLat = Double(latti)
        //print lattitude
        print(userLat)
        calculateXY(userLat!,userLon: userLon!)
        //calculate coordiantes distance
        
        userLocation = latti+","+longi
        //print location
        print(userLocation)
        //return location
        return userLocation
    }
    
    func getBuildingDetails(actionType: String){
        let userLocation = getCurrentUserLocation()
        let buildingLocation = getBuildingLocation(actionType)
        
        var distance = ""
        var duration = ""
        //set url for google maps
        let customUrl = "https://maps.googleapis.com/maps/api/distancematrix/json?origins="+userLocation+"&destinations="+buildingLocation+"&key=AIzaSyBJqMzuu3UWQYuipwbPoePfSkVB2D0_O3I"
        
        let url = NSURL(string: customUrl)
        //set task
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            do{
                let jsonResult = try (NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary)
                let rowArray = jsonResult["rows"] as! NSArray
               //parse data
                for row in rowArray {
                    //parse array
                    let obj = row as! NSDictionary
                    
                    for (_, value) in obj {
                        let elementArray = value as! NSArray
                        for element in elementArray{
                            let innerObj = element as! NSDictionary
                            
                            for(key2, value2) in innerObj{
                                let name = key2 as! String
                                if(name == "distance"){
                                    let distanceObj = value2 as! NSDictionary
                                    for(key3, value3) in distanceObj{
                                        let keyName = key3 as! String
                                        if(keyName == "text"){
                                            distance = value3 as! String
                                            print(distance)
                                        }
                                    }
                                }
                                
                                if(name == "duration"){
                                    let durationObj = value2 as! NSDictionary
                                    for(key3, value3) in durationObj{
                                        let keyName = key3 as! String
                                        if(keyName == "text"){
                                            duration = value3 as! String
                                            print(duration)
                                        }
                                    }
                                }
                            }
                            
                            print("Result:"+duration+":"+distance)
                            self.startNewScreen(actionType, distance: distance, duration: duration)
                        }
                    }
                    
                }
            }catch{
                print(error)
            }
        }
        
        task.resume()
    }
    
    func startNewScreen(actionType: String, distance: String, duration: String){
        print(actionType+":"+distance+":"+duration)
        
        dispatch_async(dispatch_get_main_queue()){
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("BuildingDetailsPage") as! BuildingDetailsView
            vc.useraction = actionType
            vc.travelDistance = distance
            vc.travelDuration = duration
            self.presentViewController(vc, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func saveDataClicked(sender: AnyObject) {
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(self.scrollview.zoomScale, forKey: "zoomDefaultLevel")
        defaults.synchronize()
    }
    
    @IBAction func loadDataClicked(sender: AnyObject) {
        
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if let defaultZoomLevel = defaults.objectForKey("zoomDefaultLevel") as? CGFloat {
            self.scrollview.zoomScale = defaultZoomLevel
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("search button Came")
        if(plotImage != nil){
            plotImage!.removeFromSuperview()
            plotImage = nil
        }
        
        print("search button clicked")
        
        if(searchBar.text?.lowercaseString == "king library" || searchBar.text?.lowercaseString == "king" ){
            let scrollPoint = CGPointMake(-120, -60)
            
            scrollview.setZoomScale(1, animated: false)
            
            scrollview.setContentOffset(scrollPoint, animated: false)
            
            
            
            plotImage = UIImageView(frame:CGRectMake(20, 220, 20, 20));
            
            plotImage!.image = UIImage(named:"pin_icon.gif")
            
            imageview.addSubview(plotImage!)
            
            
            
        }
         //check conditions
        else if(searchBar.text?.lowercaseString == "engineering building" || searchBar.text?.lowercaseString == "eng")
            
        {
            
            let scrollPoint = CGPointMake(20, -180)
            
            scrollview.setZoomScale(1, animated: false)
            
            scrollview.setContentOffset(scrollPoint, animated: false)
            
            
            
            
            
            plotImage = UIImageView(frame:CGRectMake(180, 100, 20, 20));
            
            plotImage!.image = UIImage(named:"pin_icon.gif")
            
            imageview.addSubview(plotImage!)
            
            
            
            
            
        }
            
            
        //check for U hall
        else if (searchBar.text?.lowercaseString == "yoshihiro uchida hall" || searchBar.text?.lowercaseString == "yuh")
            
        {
            
            let scrollPoint = CGPointMake(-80, 170)
            
            scrollview.setZoomScale(1, animated: false)
            
            scrollview.setContentOffset(scrollPoint, animated: false)
            
            
            plotImage = UIImageView(frame:CGRectMake(75, 390, 20, 20));
            
            plotImage!.image = UIImage(named:"pin_icon.gif")
            
            imageview.addSubview(plotImage!)
        }
            
          //check for student union
            
        else if(searchBar.text?.lowercaseString == "student union" || searchBar.text?.lowercaseString == "su")
            
        {
            
            let scrollPoint = CGPointMake(40, -90)
            
            scrollview.setZoomScale(1, animated: false)
            
            scrollview.setContentOffset(scrollPoint, animated: false)
            
            
            
            plotImage = UIImageView(frame:CGRectMake(200, 180, 20, 20));
            //set image
            plotImage!.image = UIImage(named:"pin_icon.gif")
            
            imageview.addSubview(plotImage!)
            
            
            
        }
            
            
            
        else if (searchBar.text?.lowercaseString == "bbc")
            
        {
            
            let scrollPoint = CGPointMake(110, -100)
            //set content
            
            scrollview.setZoomScale(1, animated: false)
            //set scroll view
            
            scrollview.setContentOffset(scrollPoint, animated: false)
            //plot image
            
            
            plotImage = UIImageView(frame:CGRectMake(290, 150, 20, 20));
            
            plotImage!.image = UIImage(named:"pin_icon.gif")
            
            imageview.addSubview(plotImage!)
            
            
            
        }
            
            
            
        else if (searchBar.text?.lowercaseString == "south parking garage")
            
        {
            
            let scrollPoint = CGPointMake(30, 200)
            //set scroll view
            scrollview.setZoomScale(1, animated: false)
            //set content
            scrollview.setContentOffset(scrollPoint, animated: false)
            
            //set image point
            
            plotImage = UIImageView(frame:CGRectMake(200, 430, 20, 20));
            //set image
            
            plotImage!.image = UIImage(named:"pin_icon.gif")
            //set subview
            
            imageview.addSubview(plotImage!)
            
            
            
        }
            
            
            
        else{
            let alertController = UIAlertController(title: "Search Failed", message:"Wrong Keyword. Choose from King Library, Engineering Building, Yoshihiro Uchida Hall, Student Union, BBC, South Parking Garage", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        if(plotImage != nil){
            plotImage!.removeFromSuperview()
            plotImage = nil
        }
        let scrollPoint = CGPointMake(0, 0)
        scrollview.setZoomScale(1, animated: false)
        scrollview.setContentOffset(scrollPoint, animated: false)
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    func calculateXY(userLat: Double, userLon: Double) {
        print("IN CALCULATE")
        let bounds = UIScreen.mainScreen().bounds
        let width = bounds.size.width
        let height = bounds.size.height
        let imageHeight = height
        let imageWidth = width
        
        //let userLat = 37.334761//37.334210
        //let userLon = -121.883894//-121.878595
        
        print(userLat)
        print(userLon)
        
        let x_new = Double (imageWidth) * (fabs(userLon)  - 121.886478) / (121.876243 - 121.886478)
        let y_new = Double( imageHeight) - (Double( imageHeight) * (fabs(userLat)-37.331361)/(37.338800-37.331361))
        print("imageX")
        print(x_new)
        print("imageY")
        print(y_new)
        
        var pinImageView : UIImageView
        
        pinImageView = UIImageView(frame: CGRectMake(CGFloat(x_new), CGFloat( y_new), 20, 20))
        
        pinImageView.image = UIImage(named: "pin_location.png")
        imageview
            .addSubview(pinImageView)
        
    }
    
    
}
