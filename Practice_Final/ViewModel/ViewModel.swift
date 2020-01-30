//
//  ViewModel.swift
//  Practice_Final
//
//  Created by Rakesh Nangunoori on 30/01/20.
//  Copyright © 2020 Rakesh Nangunoori. All rights reserved.
//

import UIKit
import Foundation

class ViewModel: NSObject {
    static let shared : ViewModel = {
              let instance = ViewModel()
              return instance
          }()
    
    var postModel = [PostModel]()
    var totalPages = Int()
    var currentPage = Int()
    var pageCount = Int()
    
    func getPosts(complitionHandler:@escaping(_ error:NSError?)-> Void){
        ApiCalling.shared.gettingDetailsFromServer(url: "\(BASE_URL)\(pageCount)") { (responseData, error) in
            if error == nil{
                print(responseData)
                
                if responseData?.object(forKey: "nbPages") != nil{
                    let total = String(describing: responseData!.object(forKey: "nbPages")!)
                    self.totalPages = Int(total) ?? 0
                }
                if responseData?.object(forKey: "page") != nil{
                    let current = String(describing: responseData!.object(forKey: "page")!)
                    self.currentPage = Int(current) ?? 0
                }
                
                if let arrObj = responseData?.object(forKey: "hits") as? NSArray {
                    for eachObj in arrObj {
                        let modelObj = PostModel.init(postModel: eachObj as! NSDictionary)
                        self.postModel.append(modelObj)
                    }
                    complitionHandler(nil)
                }else{
                    print("No data")
                }
            }else{
                complitionHandler(error)
            }
        }
    }
    
    func getUpdatedSwitchStatus(postModel:[PostModel],indexPath:IndexPath,complitionHandler:@escaping(_ error:NSError?)-> Void){
        postModel[indexPath.row].switchStatus =  postModel[indexPath.row].switchStatus ? false: true
        complitionHandler(nil)
    }
    
    func getDateFormatChange(date:String)-> String{
        let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let result = dateFormatter.date(from: date)
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm a"
        let requiredDate = dateFormatter1.string(from: result!)
        return requiredDate
        
    }
    
}
