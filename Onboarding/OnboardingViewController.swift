import UIKit

class OnboardingController: UIViewController, UIScrollViewDelegate {
    
    // MARK: Variables
    let backgroundColor = UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
    let slides = [
        [ "image": "slide-1@2x.png", "text": "See what you friends are posting about each other anonymously"],
        [ "image": "slide-2@2x.png", "text": "Spread joy amongst your friends and family with your secret posts!"],
        [ "image": "slide-3@2x.png", "text": "Receive alerts when your friends post their thoughts about you"],
        ]
    let screen: CGRect = UIScreen.main.bounds
    var scroll: UIScrollView?
    var dots: UIPageControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = backgroundColor
        scroll = UIScrollView(frame: CGRect(x: 0.0, y: 0.0, width: screen.width, height: screen.height * 0.9))
        scroll?.showsHorizontalScrollIndicator = false
        scroll?.showsVerticalScrollIndicator = false
        scroll?.isPagingEnabled = true
        view.addSubview(scroll!)
        
        if (slides.count > 1) {
            dots = UIPageControl(frame: CGRect(x: 0.0, y: screen.height * 0.9, width: screen.width, height: screen.height * 0.05))
            dots?.numberOfPages = slides.count
            view.addSubview(dots!)
        }
        
        for i in 0 ..< slides.count {
            if let image = UIImage(named: slides[i]["image"]!) {
                let imageView: UIImageView = UIImageView(frame: getFrame(iW: image.size.width, iH: image.size.height, slide: i, offset: screen.height * 0.15))
                imageView.image = image
                scroll?.addSubview(imageView)
            }
            if let text = slides[i]["text"] {
                let textView = UITextView(frame: CGRect(x: screen.width * 0.1 + CGFloat(i) * screen.width, y: screen.height * 0.75, width: screen.width * 0.8, height: 100.0))
                textView.text = text
                textView.isEditable = false
                textView.isSelectable = false
                textView.textAlignment = NSTextAlignment.center
                textView.font = UIFont(name: "Helvetica Neue", size: 17)
                textView.textColor = UIColor.white
                textView.backgroundColor = UIColor.clear
                scroll?.addSubview(textView)
            }
        }
        
        scroll?.contentSize = CGSize(width: CGFloat(Int(screen.width) *  slides.count), height: screen.height * 0.5)
        scroll?.delegate = self
        dots?.addTarget(self, action: Selector(("swipe:")), for: UIControlEvents.valueChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getFrame (iW: CGFloat, iH: CGFloat, slide: Int, offset: CGFloat) -> CGRect {
        let mH: CGFloat = screen.height * 0.50
        let mW: CGFloat = screen.width
        var h: CGFloat
        var w: CGFloat
        let r = iW / iH
    
        if (r <= 1) {
            h = min(mH, iH)
            w = h * r
        } else {
            w = min(mW, iW)
            h = w / r
        }
        return CGRect(
            x: max(0, (mW - w) / 2) + CGFloat(slide) * screen.width,
            y:max(0, (mH - h) / 2) + offset,
            width: w,
            height: h
        )
    }
    
    func swipe(sender: AnyObject) -> () {
        if let scrollView = scroll {
            let x = CGFloat(dots!.currentPage) * scrollView.frame.size.width
            scroll?.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) -> () {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        dots!.currentPage = Int(pageNumber)
    }
}
