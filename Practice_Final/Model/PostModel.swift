//
//  PostModel.swift
//  Practice_Final
//
//  Created by Rakesh Nangunoori on 30/01/20.
//  Copyright © 2020 Rakesh Nangunoori. All rights reserved.
//

import Foundation
import UIKit

class PostModel {
    var title = String()
    var createdDate = String()
    var switchStatus = false
    
    init(postModel:NSDictionary) {
        if let title1 = postModel.object(forKey: serverkeys.title){
            self.title = title1 as! String
        }
        if let createdDate1 = postModel.object(forKey: serverkeys.createdDate){
            self.createdDate = createdDate1 as! String
        }
    }
}
