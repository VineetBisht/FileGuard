import UIKit
@IBDesignable
class Gradient:UIView{
    @IBInspectable var FirstColor:UIColor = UIColor.clear{
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var SecondColor:UIColor = UIColor.clear{
        didSet{
            updateView()
        }
    }
    
    override class var layerClass: AnyClass{
        get{
            return CAGradientLayer.self
        }
    }
    
    func updateView(){
        let layer = self.layer as! CAGradientLayer
        layer.colors = [FirstColor.cgColor, SecondColor.cgColor ]
    }
}
