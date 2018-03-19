//
//  Question.swift
//  TwoPlayerQuestionGame
//
//  Created by Vasileios Diamantidis on 23/10/2017.
//  Copyright © 2017 vdiamant. All rights reserved.
//

import Foundation
import ObjectMapper

class Question: Mappable{
    
    var Question:String = ""
    var wrongAnswers:[String] = []
    var correctAnswer:String = ""
    var tmpAnswer:String = ""
    var Category:String = ""
    
    public init(_ quest: String,_ wa: [String],_ ca: String ){
        self.Question = quest
        self.wrongAnswers = wa
        self.correctAnswer = ca
    }
    
    public init?(){
        
    }
    
    required public init?(map: Map){
        mapping(map: map)
    }
    
    public func getQuestion() -> String{
        return self.Question
    }
    
    public init(_ Categ: String,_ Quest: String,_ wrongAns1: String,_ wrongAns2: String,_ wrongAns3: String,_ corrAns: String){
        self.Category = Categ
        self.Question = Quest
        self.wrongAnswers.append(wrongAns1)
        self.wrongAnswers.append(wrongAns2)
        self.wrongAnswers.append(wrongAns3)
        self.correctAnswer = corrAns
        
        
    }
    
    
    
    public func mapping(map: Map){
        Question <- map["title"]
        wrongAnswers = []
        tmpAnswer <- map["date"]
        wrongAnswers.append(tmpAnswer)
        tmpAnswer <- map["id"]
        wrongAnswers.append(tmpAnswer)
        tmpAnswer <- map["author"]
        wrongAnswers.append(tmpAnswer)
        
        correctAnswer <- map["time"]
        
    }
    
    
    public func shuffleStaff() -> [String]{
        var newArray = self.wrongAnswers
        newArray.append(self.correctAnswer)
        for k in 0...20{
        for i in 0..<(self.wrongAnswers.count - 1) {
            let j = Int(arc4random_uniform(UInt32(newArray.count - i))) + i
            newArray.swapAt(i, j)
        }
        }
        return newArray
    }
    
    
    
    public func getWrongAnswers()->[String]{
        return self.wrongAnswers
    }
    public func getCorrectAnswer() -> String{
        return self.correctAnswer
    }
    
    
    public func toString() -> String{
        return("Questinon: \(self.Question) Correct: \(self.correctAnswer) Wrong1: \(self.wrongAnswers[0]) Wrong2: \(self.wrongAnswers[1]) Wrong3: \(self.wrongAnswers[2]) Correct: \(self.correctAnswer)")
    }
    
    
    public func changeItsValue(_ randQuestion: Question){
        self.Category = randQuestion.Category
        self.correctAnswer = randQuestion.correctAnswer
        self.wrongAnswers.removeAll()
        for answ in randQuestion.wrongAnswers{
            self.wrongAnswers.append(answ)
        }
        self.Question = randQuestion.Question
        
    }
    
    
    
    
    
    
}
