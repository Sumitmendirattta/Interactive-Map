import Foundation
import UIKit

class BuildingDetailsView : UIViewController{


    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var buildingname: UILabel!
    @IBOutlet weak var distanceDetail: UILabel!
    @IBOutlet weak var durationDetail: UILabel!
    
    @IBOutlet weak var address1: UILabel!
    @IBOutlet weak var address3: UILabel!
    @IBOutlet weak var address2: UILabel!
    
    var useraction = String()
    var travelDistance = String()
    var travelDuration = String()
    
    override func viewDidLoad() {
        
        if(useraction == "KING"){
            buildingname.text = "King Jr Library"
            address1.text = "Dr. Martin Luther King, Jr. Library,"
            address2.text = "150, E. San Fernando St,"
            address3.text = "SJ, California 95113"
            image.image = UIImage(named: "KingLibrary.jpg")
        }else if(useraction == "ENG"){
            buildingname.text = "Engineering Building"
            address1.text = "C W. Davidson College Eng."
            address2.text = " 1 Washington Square Hall,"
            address3.text = "SJ, California 95113"
            image.image = UIImage(named: "EngBuilding.jpg")
        }else if(useraction == "YUH"){
            buildingname.text = "Yoshihiro UC Hall"
            address1.text = "Y U Hall,"
            address2.text = "1 Washington Square,"
            address3.text = "SJ , California 95113"
            image.image = UIImage(named: "UchidaHall.jpg")
        }else if(useraction == "SU"){
            buildingname.text = "Student Union"
            address1.text = "Student UN. Blding,"
            address2.text = "1 Washington Square,"
            address3.text = "SJ, California 95113"
            image.image = UIImage(named: "StudentUnion.jpg")
        }else if(useraction == "BBC"){
            buildingname.text = "BBC"
            address1.text = "Boccardo Business Complex,"
            address2.text = "1 Washington Sq.,"
            address3.text = "SJ, California 95113"
            image.image = UIImage(named: "BBC.jpg")
        }else if(useraction == "SPG"){
            buildingname.text = "South Parking Garage"
            address1.text = "SJSU South Garage,"
            address2.text = "330 South 7th Street,"
            address3.text = "SJ, California 95113"
            image.image = UIImage(named: "SouthParking.jpg")
        }
        
        distanceDetail.text = travelDistance
        durationDetail.text = travelDuration
    }
}