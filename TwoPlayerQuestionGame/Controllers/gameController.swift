//
//  gameController.swift
//  TwoPlayerQuestionGame
//
//  Created by Vasileios Diamantidis on 23/10/2017.
//  Copyright © 2017 vdiamant. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper


class gameController: UIViewController {

    
    let shapeLayer = CAShapeLayer()
    let shapeLayer2 = CAShapeLayer()
    var NoImageYet:Bool = true
    
    var userNumber = UserNumbers()
    
    
    var threadSecond:Int = 0
    
    var myArrow = UIImageView(image: UIImage(named: "arrow.png"))
    
    @IBOutlet weak var centerView: UIView!
    
    var tenQuestions:[Question] = []
    var timer:Timer = Timer()
    
    var firstWePlay:Bool = true
    
    @IBOutlet weak var viewShowScoreplayer1: UIView!
    @IBOutlet weak var viewShowScoreplayer2: UIView!
    
    var myWinImages:[UIImage] = [UIImage(named: "win.png")!,UIImage(named: "win2.png")!,UIImage(named: "win3.png")!,UIImage(named: "win4.png")!,UIImage(named: "win5.png")!,UIImage(named: "win6.png")!]
    
    var metr:Int = 0
    
    
    var scorep1:Int = 0
    var scorep2:Int = 0
    
    
    var player1Name :String = ""
    var player2Name :String = ""
    
    
    
    @IBOutlet weak var showScorep2p1: UILabel!
    @IBOutlet weak var showScorep2p2: UILabel!
    @IBOutlet weak var showScorep1p1: UILabel!
    @IBOutlet weak var showScorep1p2: UILabel!
    
    var p1MustPlay = true
    
    var errorOnNetwork = false
    
    
    var Category: String = ""
    
    
    @IBOutlet weak var viewp2: UIView!
    @IBOutlet weak var viewp1: UIView!
    
    @IBOutlet weak var p11: UIButton!
    @IBOutlet weak var p12: UIButton!
    @IBOutlet weak var p13: UIButton!
    @IBOutlet weak var p14: UIButton!
    
    @IBOutlet weak var p21: UIButton!
    @IBOutlet weak var p22: UIButton!
    @IBOutlet weak var p23: UIButton!
    @IBOutlet weak var p24: UIButton!
    
    var listlOfButtons:[UIButton]!
    
    //Labels
    
    @IBOutlet weak var lblq1: UILabel!
    @IBOutlet weak var lblq2: UILabel!
    //@IBOutlet weak var lbln1: UILabel!
    //@IBOutlet weak var lbln2: UILabel!
    
    
    var lblTimerPlayer1 = UILabel()
    var lblTimerPlayer2 = UILabel()
    
    var myQuestionGetter:questionsGetter = questionsGetter("")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myQuestionGetter = questionsGetter(Category)
        fixButtonAppearence()
        fixViewsAppearence()
        self.getTenQuestions()
        fixLabelsAppearence()
        listlOfButtons = [self.p11,self.p12,self.p13,self.p14,self.p21,self.p22,self.p23,self.p24]
        for button in self.listlOfButtons{
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 3, height: 3)
            button.layer.shadowRadius = 5
            button.layer.shadowOpacity = 1.0
        }
        addCircle()
        self.enableDisableButtons(false)
        updatePlayerNames()
        
        fixLabels()
        
        self.lblTimerPlayer1.text = "10"
        self.lblTimerPlayer2.text = "10"
        self.view.backgroundColor = UIColor(displayP3Red: 0.42, green: 0.96, blue: 0.91, alpha: 1.0)
        
        self.addLineOnCenter()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addArrow()
     }
    
    private func place(){
        print("place()")
        lblq1.text = tenQuestions[metr].getQuestion()
        lblq2.text = tenQuestions[metr].getQuestion()
        var answers = tenQuestions[metr].shuffleStaff()
        p14.setTitle(answers[0], for: .normal)
        p21.setTitle(answers[0], for: .normal)
        
        p13.setTitle(answers[1], for: .normal)
        p22.setTitle(answers[1], for: .normal)
        
        p12.setTitle(answers[2], for: .normal)
        p23.setTitle(answers[2], for: .normal)
        
        p11.setTitle(answers[3], for: .normal)
        p24.setTitle(answers[3], for: .normal)
    }
    
    private func disableEnableClick(_ pass: Bool){
        print("disableEnableClick()")
        p11.isEnabled = pass
        p12.isEnabled = pass
        p13.isEnabled = pass
        p14.isEnabled = pass
        p21.isEnabled = pass
        p22.isEnabled = pass
        p23.isEnabled = pass
        p24.isEnabled = pass
        
        if(!pass){
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.disableEnableClick(true)
                
            })
            
        
        }
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        print("checkAnswer()")
        self.lblTimerPlayer1.text = "10"
        self.lblTimerPlayer2.text = "10"
        if(sender.titleLabel?.text == "Loading..."){return}
        if(sender.titleLabel?.text == self.tenQuestions[metr].getCorrectAnswer()){
            sender.backgroundColor = UIColor.green
            scorep1+=1
        }else{
            showCorrect()
            scorep2+=1
            sender.backgroundColor = UIColor.red
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            sender.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1.0)
            
        })
        print("Player 1 \(scorep1) : \(scorep2) Player 2")
        checkWinner()
        newQuestion()
    }
    
    private func checkWinner(){
        print("checkWinner()")
        self.updatePlayerNames()
        if(scorep1>=10){
            playerWon(self.player1Name)
            self.showMyWinXib(false)
            timer.invalidate()
        }else if(scorep2>=10){
            playerWon(self.player2Name)
            self.showMyWinXib(true)
            timer.invalidate()
        }else{
            disableEnableClick(false)
        }
    }
    
    private func playerWon(_ player: String){
        print("playerWon()")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            let alert = UIAlertController(title: "Congratulations!!! \(player)", message: "Score: \(self.player1Name): \(self.scorep1) : \(self.scorep2) \(self.player2Name)", preferredStyle: .actionSheet)
            
            let restartAction = UIAlertAction(title: "Restart", style: .default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                self.restartGame()
            })
            
            let selectCategoryAction = UIAlertAction(title: "Select Category", style: .default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                self.goToSelectCategory()
                //WriteCodeTo restart game
                
            })
            
            let exitAction = UIAlertAction(title: "Exit", style: .default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                exit(0)
            })
            
            alert.addAction(restartAction)
            alert.addAction(selectCategoryAction)
            alert.addAction(exitAction)
            
            if let popoverController = alert.popoverPresentationController {
                //popoverController.barButtonItem = sender
            }
            self.present(alert, animated: true, completion: nil)
            //self.present(alert,animated: true)
        })
    }
    
    @IBAction func checkAnswerPlayer2(_ sender: UIButton) {
        print("checkAnswerPlayer2()")
        self.lblTimerPlayer1.text = "10"
        self.lblTimerPlayer2.text = "10"
        if(sender.titleLabel?.text == self.tenQuestions[metr].getCorrectAnswer()){
            sender.backgroundColor = UIColor.green
            scorep2+=1
        }else{
            scorep1+=1
            showCorrect()
            sender.backgroundColor = UIColor.red
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            sender.backgroundColor = UIColor.white
            
        })
        checkWinner()
        
        print("Player 1 \(scorep1) : \(scorep2) Player 2")
        disableEnableClick(false)
        newQuestion()
    }
    
    private func increaseMetr(){
        metr += 1
    }
    
    private func goToSelectCategory(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "selectCategoryController") as! selectCategoryController
        nextViewController.player1Name = self.player1Name
        nextViewController.player2Name = self.player2Name
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    private func restartGame(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "gameController") as! gameController
        nextViewController.player1Name = self.player1Name
        nextViewController.player2Name = self.player2Name
        nextViewController.Category = self.Category
        nextViewController.myQuestionGetter = questionsGetter(self.Category)
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    private func fixButtonAppearence(){
        //rotate player 2 buttons
        p11.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        p12.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        p13.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        p14.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        
        
        p11.layer.cornerRadius = 10
        p12.layer.cornerRadius = 10
        p13.layer.cornerRadius = 10
        p14.layer.cornerRadius = 10
        
        p21.layer.cornerRadius = 10
        p22.layer.cornerRadius = 10
        p23.layer.cornerRadius = 10
        p24.layer.cornerRadius = 10
        
        p11.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1.0)
        p12.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1.0)
        p13.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1.0)
        p14.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1.0)
        p21.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1.0)
        p22.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1.0)
        p23.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1.0)
        p24.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1.0)
        
        
        p11.layer.borderWidth = 1
        p12.layer.borderWidth = 1
        p13.layer.borderWidth = 1
        p14.layer.borderWidth = 1
        p21.layer.borderWidth = 1
        p22.layer.borderWidth = 1
        p23.layer.borderWidth = 1
        p24.layer.borderWidth = 1
        
        p11.titleLabel?.adjustsFontSizeToFitWidth = true
        p12.titleLabel?.adjustsFontSizeToFitWidth = true
        p13.titleLabel?.adjustsFontSizeToFitWidth = true
        p14.titleLabel?.adjustsFontSizeToFitWidth = true
        p21.titleLabel?.adjustsFontSizeToFitWidth = true
        p22.titleLabel?.adjustsFontSizeToFitWidth = true
        p23.titleLabel?.adjustsFontSizeToFitWidth = true
        p24.titleLabel?.adjustsFontSizeToFitWidth = true
     }
    
    private func fixViewsAppearence(){
        
        self.view.backgroundColor = UIColor(red: 0,green: 0,blue: 255,alpha: 1)
        
        //change corner smoothnest for the same views
        self.viewp1.layer.cornerRadius = 10
        self.viewp2.layer.cornerRadius = 10
        self.centerView.layer.cornerRadius = 10
        
        
        self.viewp1.backgroundColor = UIColor(displayP3Red: 0.42, green: 0.96, blue: 0.91, alpha: 1.0)
        self.viewp2.backgroundColor = UIColor(displayP3Red: 0.42, green: 0.96, blue: 0.91, alpha: 1.0)
        self.centerView.backgroundColor = UIColor(displayP3Red: 0.42, green: 0.96, blue: 0.91, alpha: 1.0)
       }
    
    private func fixLabelsAppearence(){
        
        //label rotation for player 2
        self.lblq2.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        
        showScorep2p1.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        showScorep2p2.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        
        
        
        //label colors
        //self.lbln1.backgroundColor = UIColor(red: 150,green: 150, blue: 150, alpha: 1)
        showScorep1p1.backgroundColor = UIColor(displayP3Red: 0.42, green: 0.96, blue: 0.91, alpha: 1.0)
        showScorep1p2.backgroundColor = UIColor(displayP3Red: 0.42, green: 0.96, blue: 0.91, alpha: 1.0)
        showScorep2p1.backgroundColor = UIColor(displayP3Red: 0.42, green: 0.96, blue: 0.91, alpha: 1.0)
        showScorep2p2.backgroundColor = UIColor(displayP3Red: 0.42, green: 0.96, blue: 0.91, alpha: 1.0)
        
        //self.lbln2.backgroundColor = UIColor(red: 150,green: 150, blue: 150, alpha: 1)
        
        //label corner smoothness
        //self.lbln2.layer.cornerRadius = 10
        //self.lbln1.layer.cornerRadius = 10
        showScorep1p1.layer.cornerRadius = 10
        showScorep1p2.layer.cornerRadius = 10
        showScorep2p1.layer.cornerRadius = 10
        showScorep2p2.layer.cornerRadius = 10
        self.lblq1.layer.cornerRadius = 10
        self.lblq2.layer.cornerRadius = 10
        
        //self.lbln1.autoresizesSubviews = true
        //self.lbln2.autoresizesSubviews = true
        showScorep1p1.autoresizesSubviews = true
        showScorep1p2.autoresizesSubviews = true
        showScorep2p1.autoresizesSubviews = true
        showScorep2p2.autoresizesSubviews = true
        
        self.lblq1.autoresizesSubviews = true
        self.lblq2.autoresizesSubviews = true
        
        //self.lbln1.adjustsFontSizeToFitWidth = true
        //self.lbln2.adjustsFontSizeToFitWidth = true
        
        showScorep1p1.adjustsFontSizeToFitWidth = true
        showScorep1p2.adjustsFontSizeToFitWidth = true
        showScorep2p1.adjustsFontSizeToFitWidth = true
        showScorep2p2.adjustsFontSizeToFitWidth = true
        self.lblq1.adjustsFontSizeToFitWidth = true
        self.lblq2.adjustsFontSizeToFitWidth = true
        
        self.lblq1.layer.cornerRadius = 5
        self.lblq2.layer.cornerRadius = 5
        
        
        self.viewShowScoreplayer1.layer.cornerRadius = 10
        self.viewShowScoreplayer2.layer.cornerRadius = 10
        
        self.lblq1.layer.borderWidth = 1
        self.lblq2.layer.borderWidth = 1
        
        self.lblq1.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1.0)
        self.lblq2.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1.0)
        
        
        
        self.viewShowScoreplayer1.backgroundColor = UIColor(displayP3Red: 0.42, green: 0.96, blue: 0.91, alpha: 1.0)
        self.viewShowScoreplayer2.backgroundColor = UIColor(displayP3Red: 0.42, green: 0.96, blue: 0.91, alpha: 1.0)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    public func getTenQuestions(){
        
        let URL = "192.168.100.128:3000"
        Alamofire.request(URL).responseJSON{ (response) -> Void in
            guard response.result.isSuccess else {
                print("Error while fetching json: \(String(describing: response.result.error))")
                let alert = UIAlertController(title: "Internet Connection Problem", message: "Network is unreachble", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default, handler: { action in self.getTenQuestions()}
                ))
                //self.present(alert, animated: true, completion: nil)
                return
            }
            self.tenQuestions = Mapper<Question>().mapArray(JSONObject: response.result.value)!
            print(self.tenQuestions)
            if(self.errorOnNetwork){
                self.newQuestion()
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateAction), userInfo: nil, repeats: true)
            }
        }
        
            
            
 
    }
    
    private func updatePlayerNames(){
        print("updatePlayerNames()")
        self.showScorep1p1.text = "\(self.player1Name) \(self.scorep1)"
        self.showScorep1p2.text = "\(self.scorep2) \(self.player2Name)"
        self.showScorep2p1.text = "\(self.scorep1) \(self.player1Name)"
        self.showScorep2p2.text = "\(self.player2Name) \(self.scorep2)"
    }
    
    private func addArrow(){
        print("addArrow()")
        var myRotationTimes = Int(arc4random_uniform(4)+10)
        print(myRotationTimes)
        
        
        var myY = (self.view.frame.height)/2 - 32
        //myY -= self.showScorep1p1.frame.height / 2
        
        self.myArrow.frame = CGRect(x: (self.centerView.frame.origin.x) + ((self.centerView.bounds.size.width) / 4), y: myY, width: ((self.centerView.bounds.size.width) / 2), height: ((self.view.frame.size.height) / 8))
        
        
        self.view.addSubview(myArrow)
        
        UIView.animate(withDuration: Double(myRotationTimes / 3),delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: { () -> Void in
            
            self.myArrow.layer.anchorPoint = CGPoint(x: 0.0, y: 0.5)
            for _ in 0...(myRotationTimes){
                self.myArrow.transform = self.myArrow.transform.rotated(by: CGFloat(M_PI))
            }
            self.myArrow.transform = self.myArrow.transform.rotated(by: CGFloat(M_PI)/2)
            
        }, completion: { finished in
            self.myArrow.alpha = 0.1
            self.setFirstWhoIsPlaying(myRotationTimes)
            self.tenQuestions = self.myQuestionGetter.twentyQuestions
            if self.tenQuestions.isEmpty{
                let alert = UIAlertController(title: "Internet Connection Problem", message: "Network is unreachble", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default, handler: { action in self.restartGame()}))
                //self.present(alert, animated: true, completion: nil)
                return
            }
            if(self.errorOnNetwork == false){
                self.newQuestion()
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateAction), userInfo: nil, repeats: true)
                
            }
            self.view.layer.insertSublayer(self.myArrow.layer, below: self.lblq1.layer)
            self.view.layer.insertSublayer(self.myArrow.layer, below: self.lblq2.layer)
          })
    }
    
    private func enableDisableButtons(_ what: Bool){
        print("enableDisableButtons()")
        for button in listlOfButtons{
            button.isEnabled = what
        }
        if(what){
            mySeconds = 0
        }
    }
    
    
    private func changeArrowDirection(){
        print("changeArrowDirection()")
        UIView.animate(withDuration: Double(1),delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseInOut], animations: { () -> Void in
            self.myArrow.transform = self.myArrow.transform.rotated(by: CGFloat(M_PI))
        }, completion: nil)
    }
    
    
    
    private func setFirstWhoIsPlaying(_ num:Int){
        print("setFirstWhoIsPlaying()")
        if((num % 2)==0){
            p1MustPlay = false
        }else{
            p1MustPlay = true
        }
        
    }
    
    private func newQuestion(){
        enableDisableButtons(false)
        checkWinner()
        print("newQuestion()")
        unwornPlayer()
        increaseMetr()
        showCorrect()
        if(!firstWePlay){
            self.changeArrowDirection()
            changeWhoIsPlaying()
        }else{
            firstWePlay = false
        }
        //changeQuestion()
        mySeconds = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.place()
            self.enableDisableButtons(true)
            self.lblTimerPlayer1.text = "10"
            self.lblTimerPlayer2.text = "10"
        })
        updatePlayerNames()
    }
    
    private func changeWhoIsPlaying(){
        print("changeWhoIsPlaying()")
        p1MustPlay = !p1MustPlay
    }
    
    var mySeconds:Int = 0
    @objc private func updateAction(){
        print("updateAction()")
        mySeconds+=1
        threadSecond+=1
        //print(mySeconds)
        checkMySeconds()
    }
    
    private func checkMySeconds(){
        print("checkMySeconds()")
        if(p11.isEnabled){
            lblTimerPlayer1.text = (Int((Int(lblTimerPlayer1.text!))! - 1)).description
            lblTimerPlayer2.text = (Int((Int(lblTimerPlayer2.text!))! - 1)).description
        }
        if(mySeconds == 6){
            //print("Be CareFull Who is playing")
            wornPlayer()
        }
        if(mySeconds == 10){
            lblTimerPlayer1.text = "0"
            lblTimerPlayer2.text = "0"
            showCorrect()
            newQuestion()
            addScoreToOther()
        }
     }
    
    private func addScoreToOther(){
        print("addScoreToOther()")
        if(p1MustPlay){
            scorep1+=1
        }else{
            scorep2+=1
        }
        updatePlayerNames()
    }
    
    private func wornPlayer(){
        print("wornPlayer()")
        if(p1MustPlay){
            self.changeAnimationForTwoSecond(viewp1)
        }else{
            self.changeAnimationForTwoSecond(viewp2)
        }
    }
    
    private func unwornPlayer(){
        print("unwornPlayer()")
        if(p1MustPlay){
            self.restoreAnimationForTwoSecond(viewp1)
        }else{
            self.restoreAnimationForTwoSecond(viewp2)
        }
    }
    
    private func changeAnimationForTwoSecond(_ pView : UIView){
        print("changeAnimationForTwoSecond()")
      pView.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.5)
    }
    
    private func restoreAnimationForTwoSecond(_ pView : UIView){
        print("restoreAnimationForTwoSecond()")
       pView.backgroundColor = UIColor(displayP3Red: 0.42, green: 0.96, blue: 0.91, alpha: 1.0)
    }
    
    private func showCorrect(){
        self.enableDisableButtons(false)
        var correctContainers:[UIButton] = []
        for button in self.listlOfButtons {
            if (button.titleLabel?.text == self.tenQuestions[self.metr].getCorrectAnswer()){
                correctContainers.append(button)
            }
        }
        
        for button in correctContainers {
            button.backgroundColor = UIColor(red: 0, green: 255, blue: 0, alpha: 1)
            button.titleLabel?.textColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            for button in correctContainers {
                button.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1.0)
                button.titleLabel?.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                
                
            }
            self.enableDisableButtons(true)
            
        })
        
    }
    
    private func fixLabels(){
        self.lblTimerPlayer1 = UILabel(frame: CGRect(x: self.view.layer.bounds.width / 2, y: ((self.view.layer.bounds.height / 8) * 6.6), width: 50, height: 50))
        self.lblTimerPlayer1.center = CGPoint(x: self.view.layer.bounds.width / 2,y: ((self.view.layer.bounds.height / 8) * 6.6))
        self.lblTimerPlayer1.textAlignment = NSTextAlignment.center
        self.lblTimerPlayer1.font = UIFont.systemFont(ofSize: 20.0)
        self.view.addSubview(self.lblTimerPlayer1)
        
        self.lblTimerPlayer2 = UILabel(frame: CGRect(x: self.view.layer.bounds.width / 2, y: (self.view.layer.bounds.height / 8) + 55, width: 50, height: 50))
        self.lblTimerPlayer2.center = CGPoint(x: self.view.layer.bounds.width / 2,y: (self.view.layer.bounds.height / 8) + 55 )
        self.lblTimerPlayer2.textAlignment = NSTextAlignment.center
        self.lblTimerPlayer2.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        self.lblTimerPlayer2.font = UIFont.systemFont(ofSize: 20.0)
        //self.lblTimerPlayer2.textColor = UIColor.black
        self.view.addSubview(self.lblTimerPlayer2)
        
    }
    
    private func addLineOnCenter(){
        
        var myY = ((self.view.frame.size.height) / 16) + (self.view.frame.height)/2 - 32
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.view.bounds.width, y: myY))
        path.addLine(to: CGPoint(x: 0, y: myY))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 5
        
        self.view.layer.addSublayer(shapeLayer)
    }
    
    private func addCircle(){
        
        print("self.viewp1.frame.origin.x: \(self.viewp1.frame.origin.y)")
        print("self.viewp1.layer.bounds.height: \(self.viewp1.layer.bounds.height)")
        
        //let myY = ((self.view.layer.bounds.height / 4) * 3)
        //let myX = (self.view.layer.bounds.width / 2)
        
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: (self.view.layer.bounds.width / 2), y: ((self.view.layer.bounds.height / 8) * 6.6)), radius: CGFloat(20), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        shapeLayer.path = circlePath.cgPath
        //change the fill color
        shapeLayer.fillColor = UIColor.yellow.cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor.red.cgColor
        //you can change the line width
        shapeLayer.lineWidth = 1.0
        shapeLayer.addSublayer(lblTimerPlayer1.layer)
        view.layer.addSublayer(shapeLayer)
        //lblTimerPlayer1.layer.position = CGPoint(x: shapeLayer.frame.midX,y: shapeLayer.frame.midY)
        //view.addSubview(lblTimerPlayer1)
        
        let circlePath2 = UIBezierPath(arcCenter: CGPoint(x: (self.view.layer.bounds.width / 2), y: ((self.view.layer.bounds.height / 8) + 55 )), radius: CGFloat(20), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        shapeLayer2.path = circlePath2.cgPath
        //change the fill color
        shapeLayer2.fillColor = UIColor.yellow.cgColor
        //you can change the stroke color
        shapeLayer2.strokeColor = UIColor.red.cgColor
        //you can change the line width
        shapeLayer2.lineWidth = 1.0
        shapeLayer2.addSublayer(lblTimerPlayer2.layer)
        view.layer.addSublayer(shapeLayer2)
        //lblTimerPlayer2.layer.position = CGPoint(x: shapeLayer2.frame.midX,y: shapeLayer2.frame.midY)
        //view.addSubview(lblTimerPlayer2)
    }
    
    private func showMyWinXib(_ shouldIRotate: Bool){
        if(NoImageYet){
        let winImage:UIImageView = UIImageView(frame:CGRect(x: (self.view.bounds.width / 2) - 100,y: (self.view.bounds.height / 4) * 3,width: 200,height: 150))
        
        if(shouldIRotate){
            winImage.frame.origin.y = (self.view.bounds.height / 4) - 150
            winImage.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
        winImage.image = myWinImages[Int(arc4random_uniform(6))]
        winImage.window?.windowLevel = UIWindowLevelStatusBar + 100.0
        self.view.addSubview(winImage)
        }
        NoImageYet = false
    }    
}
