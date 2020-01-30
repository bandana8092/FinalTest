//
//  ApiCalling.swift
//  Practice_Final
//
//  Created by Rakesh Nangunoori on 30/01/20.
//  Copyright © 2020 Rakesh Nangunoori. All rights reserved.
//

import UIKit
import Foundation

class ApiCalling: NSObject {
    
    static let shared : ApiCalling = {
        let instance = ApiCalling()
        return instance
    }()
    
    func gettingDetailsFromServer(url:String,complitionHandler:@escaping(_ response:NSDictionary?,_ error:NSError?)-> Void){
        
        let finalUrl = URL(string: url)
        let request = URLRequest(url: finalUrl!)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (Data, urlResponse, error) in
            if Data == nil{
                
            }else{
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: Data!, options: .mutableContainers)
                    print(jsonResult)
                    complitionHandler(jsonResult as? NSDictionary,nil)
                } catch  {
                    complitionHandler(nil,error as NSError)
                }
            }
        }
        
        task.resume()
    }

}
