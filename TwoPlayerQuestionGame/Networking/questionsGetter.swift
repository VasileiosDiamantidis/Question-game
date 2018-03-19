//
//  questionsGetter.swift
//  TwoPlayerQuestionGame
//
//  Created by Vasileios Diamantidis on 06/11/2017.
//  Copyright © 2017 vdiamant. All rights reserved.
//

import Foundation
import FirebaseDatabase

class questionsGetter{
    var ref: DatabaseReference!
    
    var twentyQuestions:[Question] = []
    var allQuestions:[Question] = []
    
    
    
    
    init(_ categ: String){
        if(categ==""){
            return
        }else{
            getQuestionsBasedOnCategory(categ)
        }
    }
    
   
    
    
    public func getQuestionsBasedOnCategory(_ Category: String){
        var myArrayOfQuestions:[Question] = []
        ref = Database.database().reference()
        var other:DatabaseQuery = DatabaseQuery()
        
        if(Category == "Random"){
            var myTmpInt =  Int(arc4random_uniform(978)+1)
            other = ref.child("Questions").queryOrdered(byChild: "Enumeration").queryStarting(atValue: myTmpInt).queryEnding(atValue: myTmpInt + 20)
        }else{
            other = ref.child("Questions").queryOrdered(byChild: "Category").queryEqual(toValue: Category)
        //print(other)
        }
        initializeEachQuestion(other)
        
         
            
        
    }
    
    
    
    private func initializeEachQuestion(_ other: DatabaseQuery) {
        var myArrayOfQuestions:[Question] = []
        other.observeSingleEvent(of: .value, with: { snapshot in
        var category=""
        var swsthApanthsh=""
        var lathos1=""
        var lathos2=""
        var lathos3=""
        var questionString=""
        var myTmpCounter:Int=0
        for rest in snapshot.children.allObjects as! [DataSnapshot] {
            //self.Qfix(rest.key)
            var atributes = rest.children.allObjects
            for atr in atributes{
                var mytmpAtr = atr as! DataSnapshot
                var mtTmpOptional = mytmpAtr.value.debugDescription
                //print(self.removeUselessCharacters(mtTmpOptional))
                switch(myTmpCounter){
                case 0:
                    category = self.removeUselessCharacters(mtTmpOptional)
                    break
                case 1:
                    swsthApanthsh = self.removeUselessCharacters(mtTmpOptional)
                    break
                case 2:
                    break
                case 3:
                    questionString = self.removeUselessCharacters(mtTmpOptional)
                    break
                case 4:
                    lathos1 = self.removeUselessCharacters(mtTmpOptional)
                    break
                case 5:
                    lathos2 = self.removeUselessCharacters(mtTmpOptional)
                    break
                case 6:
                    lathos3 = self.removeUselessCharacters(mtTmpOptional)
                    break
                default:
                    print("Default!")
                    
                    //print(atr)
                }
                myTmpCounter+=1
                //print(atributes)
                //print(rest.key)
                var questionString = rest.key
            }
            myTmpCounter = 0
            var myTmpQuestion = Question(category,questionString,lathos1,lathos2,lathos3,swsthApanthsh)
            print(myTmpQuestion.toString())
            self.allQuestions.append(myTmpQuestion)
            }
            self.mySuffle()
            self.pickTwentyQuestions()
            
        })
        
       
    }
    
    
    
    
    
    
    private func removeUselessCharacters(_ mtTmpOpt: String) -> String{
        var tmpString:String=""
        var count:Int = 0
        for chara in mtTmpOpt{
            if(count>=9 && count < mtTmpOpt.count-1){
                tmpString=tmpString.description + chara.description
             }
            count+=1
        }
        return tmpString
    }
    
    
    
    private func pickTwentyQuestions(){
        var tmpArrayOfPositions:[Int]=[]
        for i in 1...20{
            var tmpPosition:Int = Int(arc4random_uniform(UInt32(self.allQuestions.count)))
            while (tmpArrayOfPositions.contains(tmpPosition)){
            tmpPosition = Int(arc4random_uniform(UInt32(self.allQuestions.count)))
            }
            tmpArrayOfPositions.append(tmpPosition)
        }
        var twentyQuestions:[Question] = []
        for thesi in tmpArrayOfPositions{
            self.twentyQuestions.append(self.allQuestions[thesi])
        }
        
        
        
        
    }
    
    
    func mySuffle() {
        for i in 0...(self.allQuestions.count - 1){
            var tmpPosition:Int = Int(arc4random_uniform(UInt32(self.allQuestions.count)))
            var tmpQuestion = self.allQuestions[tmpPosition]
            self.allQuestions[tmpPosition].changeItsValue(self.allQuestions[i])
            self.allQuestions[i].changeItsValue(tmpQuestion)
            
            
        }
    }
    
    
    
}
