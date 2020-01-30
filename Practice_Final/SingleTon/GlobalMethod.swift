//
//  GlobalMethod.swift
//  Practice_Final
//
//  Created by Rakesh Nangunoori on 30/01/20.
//  Copyright © 2020 Rakesh Nangunoori. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration

class GlobalMethod: NSObject {
    static let shared : GlobalMethod = {
           let instance = GlobalMethod()
           return instance
       }()
    
     func showActivityIndicator(view: UIView, targetVC: UIViewController) {

        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.backgroundColor = UIColor.lightGray
        activityIndicator.layer.cornerRadius = 6
        activityIndicator.center = targetVC.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.tag = 1
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
    }

     func hideActivityIndicator(view: UIView) {
        let activityIndicator = view.viewWithTag(1) as? UIActivityIndicatorView
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
        
    }
     func isConnectedToNetwork() -> Bool {
           var zeroAddress = sockaddr_in()
           zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
           zeroAddress.sin_family = sa_family_t(AF_INET)

           guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
               $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                   SCNetworkReachabilityCreateWithAddress(nil, $0)
               }
           }) else {
               return false
           }

           var flags: SCNetworkReachabilityFlags = []
           if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
               return false
           }
           if flags.isEmpty {
               return false
           }

           let isReachable = flags.contains(.reachable)
           let needsConnection = flags.contains(.connectionRequired)

           return (isReachable && !needsConnection)
       }
}
