//
//  AnswersController.swift
//  TwoPlayerQuestionGame
//
//  Created by Vasileios Diamantidis on 12/10/2017.
//  Copyright © 2017 vdiamant. All rights reserved.
//

import UIKit

class AnswersController: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    
    
    
    @IBAction func justAnswered(_ sender: UIButton) {
        switch sender.description {
        case btn1.description:
            print("btn1 was pressed")
        case btn2.description:
            print("btn2 was pressed")
        case btn3.description:
            print("btn3 was pressed")
        case btn4.description:
            print("btn4 was pressed")
        default:
            print("None of these was pressed")
        }
        
    }
    
}
