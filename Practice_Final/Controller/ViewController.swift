//
//  ViewController.swift
//  Practice_Final
//
//  Created by Rakesh Nangunoori on 30/01/20.
//  Copyright © 2020 Rakesh Nangunoori. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    
    @IBOutlet weak var postTV: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.isHidden = true
        postTV.isHidden = true
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        postTV.addSubview(refreshControl)
        GlobalMethod.shared.showActivityIndicator(view: self.view, targetVC: self)
        if GlobalMethod.shared.isConnectedToNetwork() == true{
        ViewModel.shared.getPosts { (error) in
            if error == nil{
                DispatchQueue.main.async {
                    GlobalMethod.shared.hideActivityIndicator(view: self.view)
                    self.postTV.isHidden = false
                    self.postTV.reloadData()
                }
            }
        }
        }
        // Do any additional setup after loading the view.
    }
    @objc func refresh(sender:AnyObject) {
        postTV.isHidden = true
         //if ViewModel.shared.totalPages >   ViewModel.shared.currentPage {
            ViewModel.shared.pageCount = 0
            ViewModel.shared.postModel.removeAll()
            self.navigationItem.title = "0"
            fetchMoreData()
        //}
        
        self.postTV.reloadData()
        refreshControl.endRefreshing()
    }
    func fetchMoreData()
    {
        if GlobalMethod.shared.isConnectedToNetwork() == true{
        ViewModel.shared.getPosts { (error) in
            if error == nil{
                DispatchQueue.main.async {
                    self.postTV.isHidden = false
                    self.spinner.isHidden = true
                    self.spinner.stopAnimating()
                    self.postTV.reloadData()
                }
            }
        }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ViewModel.shared.postModel.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostsTableViewCell
        cell.updateCell(postModel: ViewModel.shared.postModel, indexPath: indexPath)
        cell.selectionStyle = .none
        return cell
       }
       
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ViewModel.shared.getUpdatedSwitchStatus(postModel: ViewModel.shared.postModel, indexPath: indexPath) { (error) in
            if error == nil{
                let filteredArr = ViewModel.shared.postModel.filter{$0.switchStatus == true}
                    
                if filteredArr.count > 0{
                    self.navigationItem.title = "\(filteredArr.count)"
                }
                else{
                    self.navigationItem.title = "0"
                }
                self.postTV.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == ViewModel.shared.postModel.count - 1{
            spinner.isHidden = false
            spinner.startAnimating()
            if ViewModel.shared.totalPages >   ViewModel.shared.currentPage {
                 ViewModel.shared.pageCount += 1
                fetchMoreData()
            }else{
                 spinner.isHidden = true
                spinner.stopAnimating()
            }
        }
    }
}

