//
//  selectCategoryController.swift
//  TwoPlayerQuestionGame
//
//  Created by Vasileios Diamantidis on 23/10/2017.
//  Copyright © 2017 vdiamant. All rights reserved.
//

import UIKit

class selectCategoryController: UIViewController {
    
    var player1Name:String = "selectCategoryController"
    var player2Name:String = "selectCategoryController"
    
    var categorySelected:String = ""
    var eightSpaceX:CGFloat=CGFloat()
    var eightSpaceY:CGFloat=CGFloat()
    
    var mybtnWidth:CGFloat = 0.0
   
    var myButtons:[UIButton]=[]
    var myScrollView:UIScrollView = UIScrollView()
    
    
    var Category = ["Animals", "Gossip", "Sports", "Cinema", "History", "Science","Random"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eightSpaceX = self.view.bounds.width / (375 / 8)
        eightSpaceY = self.view.bounds.height / (667 / 8)
        self.view.backgroundColor = UIColor(displayP3Red: 0.42, green: 0.96, blue: 0.91, alpha: 1.0)
        self.myScrollView = UIScrollView(frame: CGRect(x: (self.view.frame.width / 10), y:(self.view.frame.height / 10), width: ((self.view.frame.width / 10) * 8),height: (self.view.frame.height / 10) * 7))
        self.myScrollView.showsVerticalScrollIndicator = true;
        
        self.fixButtonAppearence()
        self.mybtnWidth = ((myScrollView.frame.width - (3 * eightSpaceX)) / 2 )
        myScrollView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleHeight.rawValue)))
        
        myScrollView.showsVerticalScrollIndicator = true
        myScrollView.isScrollEnabled = true
        myScrollView.layer.cornerRadius = 10
        myScrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(myScrollView)
        self.addButtons()
        
        self.addGradientLayer()
        
        self.addUnlockButton()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        for i in 1...((myButtons.count / 2)){
            addRowToScrollView()
            
        }
        if(myButtons.count % 2 == 1){
            addRowToScrollView()
        }
        self.myScrollView.contentSize.height += self.eightSpaceX
        addGradientLayer()
        addFunctionToButtons()
    }
    
    private func addFunctionToButtons(){
        for button in myButtons{
            button.addTarget(self, action: #selector(addTransaction), for: UIControlEvents.touchUpInside)
        }
    }
    
    @objc private func addTransaction(sender : UIButton){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "gameController") as! gameController
        nextViewController.player1Name = self.player1Name
        nextViewController.player2Name = self.player2Name
        nextViewController.Category = sender.title(for: .normal)!.description
        nextViewController.myQuestionGetter = questionsGetter(sender.title(for: .normal)!.description)
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    private func addGradientLayer(){
        var gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(displayP3Red: 0.42, green: 0.96, blue: 0.91, alpha: 1.0),UIColor.yellow]
        gradientLayer.frame = self.view.bounds
        gradientLayer.startPoint = CGPoint(x:0, y:0)
        gradientLayer.endPoint = CGPoint(x:1, y:1)
        self.view.layer.addSublayer(gradientLayer)
    }
    
    private func addRowToScrollView(){
        self.myScrollView.contentSize.height += mybtnWidth + self.eightSpaceX
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openController(_ sender: UIButton) {
        categorySelected = (sender.titleLabel?.text)!
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        let secondViewController = segue.destination as! gameController
        secondViewController.player1Name = player1Name
        secondViewController.player2Name = player2Name
        
    }
    private func addButtons(){
        var myButton:UIButton = UIButton(frame: CGRect(x: self.eightSpaceX, y: self.eightSpaceY , width: mybtnWidth, height: mybtnWidth))
        self.myButtons.append(myButton)
        myButton.setBackgroundImage(#imageLiteral(resourceName: "animals"), for: .normal)
        self.myScrollView.addSubview(myButton)
        createSubname(self.eightSpaceX,self.eightSpaceY,mybtnWidth,mybtnWidth,Category[0])
        myButton.setTitle(Category[0].description, for: .normal)
        myButton.setTitleColor(UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0), for: .normal)
        
        var myButton2 = UIButton(frame: CGRect(x: getXPosition2(),y: self.eightSpaceY, width: mybtnWidth, height: mybtnWidth))
        myButton2.setBackgroundImage(#imageLiteral(resourceName: "gossip"), for: .normal)
        self.myButtons.append(myButton2)
        self.myScrollView.addSubview(myButton2)
        createSubname(getXPosition2(),self.eightSpaceY,mybtnWidth,mybtnWidth,Category[1])
        myButton2.setTitle(Category[1].description, for: .normal)
        myButton2.setTitleColor(UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0), for: .normal)
        
        var myButton3 = UIButton(frame: CGRect(x: getXPosition1(),y: getYPosition(myButton2) , width: mybtnWidth, height: mybtnWidth))
        self.myButtons.append(myButton3)
        myButton3.setBackgroundImage(#imageLiteral(resourceName: "sports"), for: .normal)
        self.myScrollView.addSubview(myButton3)
        createSubname(getXPosition1(),getYPosition(myButton2),mybtnWidth,mybtnWidth,Category[2])
        myButton3.setTitle(Category[2].description, for: .normal)
        myButton3.setTitleColor(UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0), for: .normal)
        
        var myButton4 = UIButton(frame: CGRect(x: getXPosition2(),y: getYPosition(myButton2) , width: mybtnWidth, height: mybtnWidth))
        self.myButtons.append(myButton4)
        myButton4.setBackgroundImage(#imageLiteral(resourceName: "Cinema"), for: .normal)
        self.myScrollView.addSubview(myButton4)
        createSubname(getXPosition2(),getYPosition(myButton2),mybtnWidth,mybtnWidth,Category[3])
        myButton4.setTitle(Category[3].description, for: .normal)
        myButton4.setTitleColor(UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0), for: .normal)
        
        var myButton5 = UIButton(frame: CGRect(x: getXPosition1(),y: getYPosition(myButton4) , width: mybtnWidth, height: mybtnWidth))
        myButton5.setBackgroundImage(#imageLiteral(resourceName: "History"), for: .normal)
        self.myButtons.append(myButton5)
        self.myScrollView.addSubview(myButton5)
        createSubname(getXPosition1(),getYPosition(myButton4),mybtnWidth,mybtnWidth,Category[4])
        myButton5.setTitle(Category[4].description, for: .normal)
        myButton5.setTitleColor(UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0), for: .normal)
        
        var myButton6 = UIButton(frame: CGRect(x: getXPosition2(),y: getYPosition(myButton4) , width: mybtnWidth, height: mybtnWidth))
        self.myButtons.append(myButton6)
        myButton6.setBackgroundImage(#imageLiteral(resourceName: "Science"), for: .normal)
        self.myScrollView.addSubview(myButton6)
        createSubname(getXPosition2(),getYPosition(myButton4),mybtnWidth,mybtnWidth,Category[5])
        myButton6.setTitle(Category[5].description, for: .normal)
        myButton6.setTitleColor(UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0), for: .normal)
        
        var myButton7 = UIButton(frame: CGRect(x: getXPosition1(),y: getYPosition(myButton5) , width: mybtnWidth, height: mybtnWidth))
        self.myButtons.append(myButton7)
        
        myButton7.setBackgroundImage(#imageLiteral(resourceName: "Random"), for: .normal)
        self.myScrollView.addSubview(myButton7)
        createSubname(getXPosition1(),getYPosition(myButton5),mybtnWidth,mybtnWidth,Category[6])
        myButton7.setTitle(Category[6].description, for: .normal)
        myButton7.setTitleColor(UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0), for: .normal)
        
        fixButtonAppearence()
    }
    
    private func getYPosition(_ myButton: UIButton) -> CGFloat{
        return myButton.frame.origin.y + myButton.layer.bounds.width + self.eightSpaceY * 2
    }
    
    private func getXPosition1() -> CGFloat{
        return self.eightSpaceX
    }
    
    private func getXPosition2() -> CGFloat{
        return (((self.myScrollView.frame.width - (3 * eightSpaceX)) / 2) + (2 * self.eightSpaceX))
    }
    
    private func fixButtonAppearence(){
        
        for button in myButtons{
            button.layer.cornerRadius = 10
            button.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1.0)
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 3, height: 3)
            button.layer.shadowRadius = 5
            button.layer.shadowOpacity = 1.0
            button.setTitleColor(UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0), for: .normal)
        }
    }
    
    
    private func createSubname(_ xpos: CGFloat,_ ypos: CGFloat,_ btnWidth:CGFloat,_ btnHeight:CGFloat,_ title:String){
        var myThing:UILabel = UILabel(frame: CGRect(x: xpos + (btnWidth / 5), y: ypos + (btnHeight / 5) * 4.5, width: (btnWidth / 5) * 3, height: (btnHeight / 7)))
        myThing.layer.masksToBounds = true
        myThing.layer.cornerRadius = 10
        myThing.text = title
        myThing.textAlignment = .center
        myThing.layer.shadowColor = UIColor.black.cgColor
        myThing.layer.shadowOffset = CGSize(width: 3, height: 3)
        myThing.layer.shadowRadius = 2
        myThing.layer.shadowOpacity = 1.0
        myThing.backgroundColor = UIColor.red
        self.myScrollView.addSubview(myThing)
    }
    
    private func addUnlockButton(){
        var unlockAll:UIButton = UIButton(frame: CGRect(x:(self.view.layer.bounds.width / 10),y: self.view.layer.bounds.height / 10 * 8.5 ,width: (self.view.frame.width / 10) * 8,height: self.view.layer.bounds.height / 10))
        unlockAll.backgroundColor = UIColor.white
        unlockAll.setTitle("UNLOCK ALL", for: .normal)
        unlockAll.setTitleColor(UIColor.black, for: .normal)
        unlockAll.layer.shadowColor = UIColor.black.cgColor
        unlockAll.layer.shadowOffset = CGSize(width: 3, height: 3)
        unlockAll.layer.shadowRadius = 5
        unlockAll.layer.shadowOpacity = 1.0
        unlockAll.layer.cornerRadius = 10
        unlockAll.backgroundColor = UIColor.yellow
        
        self.view.addSubview(unlockAll)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
