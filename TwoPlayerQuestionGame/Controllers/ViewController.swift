//
//  ViewController.swift
//  TwoPlayerQuestionGame
//
//  Created by Vasileios Diamantidis on 12/10/2017.
//  Copyright © 2017 vdiamant. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import CoreData
//import FBSDKShareKit
import GoogleMobileAds
import Firebase
import FirebaseDatabase


class ViewController: UIViewController {
    @IBOutlet weak var palyer1Name: UITextField!
    @IBOutlet weak var player2Name: UITextField!
    var uNums = UserNumbers()
    @IBOutlet weak var p1txt: UITextField!
    @IBOutlet weak var p2txt: UITextField!
    @IBOutlet weak var startButton: UIButton!
    var ref: DatabaseReference!
    //var questGet = questionsGetter()
    
    //let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    var interstitial: GADInterstitial!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //questGet.getQuestions()
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.adUnitID = "ca-app-pub-7416764507139673/6907113034"
        bannerView.rootViewController = self
        bannerView.load(request)
       
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-7416764507139673/3423163597")
        
        let intRequest = GADRequest()
        interstitial.load(intRequest)
        self.view.backgroundColor = UIColor(displayP3Red: 0.42, green: 0.96, blue: 0.91, alpha: 1.0)
        var myUnum = UserNumbers()
        myUnum.getRandomNumber()
        print(myUnum.categoryOneList.description)
//        
//        var Category = ["Animals", "Gossip", "Sports", "Cinema", "History", "Science"]
//
//
//
//
//
//        for i in 1...1000{
//            var tmpCategory = Category[Int(arc4random_uniform(6))]
//            ref = Database.database().reference().child("Questions")
//            ref = Database.database().reference().child("Questions").child("erwthsh\(i)")
//            ref.setValue(["Category":tmpCategory,"Correct":"swsth\(i)","Wrong1":"Lathos1\(i)","Wrong2":"Lathos2\(i)","Wrong3":"lathos3\(i)","QuestionString":"ErwthshString\(i)","Enumeration":i])
//        }

        
        print(myUnum.categoryOneList.description)
        startButton.layer.cornerRadius = 10
        
        startButton.layer.shadowColor = UIColor.black.cgColor
        startButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        startButton.layer.shadowRadius = 5
        startButton.layer.shadowOpacity = 1.0
        startButton.backgroundColor = UIColor(displayP3Red: 0.66, green: 0.02, blue: 0.14, alpha: 1)
        
        p1txt.backgroundColor = UIColor(displayP3Red: 0.96, green: 0.68, blue: 0.73, alpha: 1.0)
        p2txt.backgroundColor = UIColor(displayP3Red: 0.96, green: 0.68, blue: 0.73, alpha: 1.0)
        
        p1txt.layer.shadowColor = UIColor.black.cgColor
        p1txt.layer.shadowOffset = CGSize(width: 3, height: 3)
        p1txt.layer.shadowRadius = 5
        p1txt.layer.shadowOpacity = 1.0
        
        p2txt.layer.shadowColor = UIColor.black.cgColor
        p2txt.layer.shadowOffset = CGSize(width: 3, height: 3)
        p2txt.layer.shadowRadius = 5
        p2txt.layer.shadowOpacity = 1.0
        //print(networkManager().getDATA())
        
        //content.contentURL = NSURL(string: "www.facebook.com/ratata")! as URL
        
//        let button = FBSDKShareButton()
//        button.shareContent = content
//        button.frame = CGRect(x: (self.view.bounds.width - 100) * 0.5, y: 50, width: 100, height: 25)
//        self.view.addSubview(button)
//
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        //tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func showAdd(_ sender: UIButton) {
            interstitial.present(fromRootViewController: self)
            interstitial = CreateAd()
    }
    
    
    func CreateAd() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-7416764507139673/3423163597")
        //interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.p1txt.resignFirstResponder()
        self.p2txt.resignFirstResponder()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //addArrow()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func passVariables(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            //addSpaces()
            let secondViewController = segue.destination as! selectCategoryController
            secondViewController.player1Name = palyer1Name.text!
            secondViewController.player2Name = player2Name.text!
       
    }
    
    var myArrow = UIImageView(image: UIImage(named: "arrow.png"))
    
    private func addArrow(){
        print("addArrow()")
        
        
        
        //myY -= self.showScorep1p1.frame.height / 2
        var myArrow = UIImageView(image: UIImage(named: "arrow.png"))
        myArrow.frame = CGRect(x: (self.view.bounds.size.width / 2) , y: (self.view.bounds.size.height / 4) * 3, width: (self.startButton.bounds.width), height: (self.startButton.bounds.height))
        
        var myArrow2 = UIImageView(image: UIImage(named: "arrow.png"))
        myArrow2.frame = CGRect(x: 0, y: (self.view.bounds.size.height / 4) * 3, width: (self.startButton.bounds.width), height: (self.startButton.bounds.height))
        
        
        self.view.addSubview(myArrow)
        self.view.addSubview(myArrow2)
        UIView.animate(withDuration: 4,delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 1, options: [.repeat], animations: { () -> Void in
            
        myArrow.layer.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        myArrow2.layer.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        myArrow.transform = myArrow.transform.rotated(by: CGFloat(M_PI))
        myArrow2.transform = myArrow2.transform.rotated(by: CGFloat(M_PI))
            
        }, completion: nil)
    }
    
//    private func addSpaces(){
//        if(player2Name.text!.count > palyer1Name.text!.count){
//            for _ in 0...(player2Name.text!.count - palyer1Name.text!.count){
//                palyer1Name.text?.insert(" ",at: (palyer1Name.text?.startIndex)!)
//            }
//        }else if(palyer1Name.text!.count > player2Name.text!.count){
//            for _ in 0...(palyer1Name.text!.count - player2Name.text!.count){
//                player2Name.text?.insert(" ",at: (palyer1Name.text?.startIndex)!)
//            }
//        }
//    }
//
//

}

