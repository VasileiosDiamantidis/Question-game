//
//  networkManager.swift
//  TwoPlayerQuestionGame
//
//  Created by Vasileios Diamantidis on 24/10/2017.
//  Copyright © 2017 vdiamant. All rights reserved.
//

import Alamofire
import ObjectMapper

class networkManager{
    
    public init(){}
    
    public func getDATA() -> [Question]{
        var myQuestions:[Question]=[Question]()
        let URL = "http://www.allaboutaris.com/json&p=1"
        Alamofire.request(URL).responseJSON{ (response) -> Void in
            guard response.result.isSuccess else {
                print("Error while fetching json: \(String(describing: response.result.error))")
                return
            }
            myQuestions = Mapper<Question>().mapArray(JSONObject: response.result.value)! 
            print(myQuestions)
        }
        return myQuestions
    }
    
    
}
