//
//  ViewController.swift
//  RxNetworkDemo
//
//  Created by Tsung Han Yu on 2017/3/22.
//  Copyright © 2017年 Boxue. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON
import RxDataSources

class ViewController: UIViewController {
    
    @IBOutlet weak var repositoryName: UITextField!
    @IBOutlet weak var searchResult: UITableView!
    
    var bag = DisposeBag()
    
    typealias SectionTableModel = SectionModel<String, RepositoryModel>
    let dataSource = RxTableViewSectionedReloadDataSource<SectionTableModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.dataSource.configureCell = {
            (_, tv, indexPath, element) in
            let cell =
                tv.dequeueReusableCell( withIdentifier: "RepositoryInfoCell", for: indexPath) as! RepositoryInfoTableViewCell
            
            cell.name.text = element.name
            cell.detail.text = element.detail
            
            return cell
        }
        
        repositoryName.rx.text
            .filter {
                $0!.characters.count > 2
            }
            .throttle(0.5, scheduler: MainScheduler.instance)
            .flatMap {
                self.searchForGithub($0!)
            }
            .subscribe(onNext: { (repositoryModelArray) in
                self.searchResult.dataSource = nil
              
                Observable.just(self.createGithubSectionModel(repositoryModelArray))
                    .bindTo(self.searchResult.rx.items(dataSource: self.dataSource))
                    .addDisposableTo(self.bag)
                
            }, onError: { (error) in
                let err = error as NSError
                self.displayErrorAlert(err)
            })
            .addDisposableTo(bag)
        
    }
}


// MARK: - Networking
extension ViewController {
    typealias RepositoryInfo = Dictionary<String, Any>
    
    fileprivate func createGithubSectionModel(_ repoInfo: [RepositoryModel]) -> [SectionTableModel] {
        
        var ret: [SectionTableModel] = []
        var items: [RepositoryModel] = []
        
        if (repoInfo.count <= 10) {
            let sectionLabel = "Top 1 - 10"
            items = repoInfo
            
            ret.append(SectionTableModel(
                model: sectionLabel, items: items))
        }
        else {
            for i in 1...repoInfo.count {
                items.append(repoInfo[i - 1])
                
                if (i / 10 != 0 && i % 10 == 0) {
                    let sectionLabel =
                    "Top \(i - 9) - \(i)"
                    
                    ret.append(SectionTableModel(model: sectionLabel, items: items))
                    
                    items = []
                }
            }
        }
        
        return ret
    }
    
    
    fileprivate func searchForGithub(_ repositoryName:String) -> Observable<[RepositoryModel]> {
        return Observable.create({ (observer) -> Disposable in
            let url = "https://api.github.com/search/repositories"
            let parameters = ["q": repositoryName]
            
            let request = Alamofire.request(url, parameters: parameters).validate().responseJSON { (response) in
                switch response.result.isSuccess {
                case true:
                    let json = response.result.value!
                    
                    let info = self.parseGithubResponse(json)
                    observer.on(.next(info))
                    observer.on(.completed)
                case false:
                    observer.on(.error(response.result.error!))
                }
            }
            return Disposables.create {
                request.cancel()
            }
        })
    }
    
    fileprivate func parseGithubResponse(_ response: Any) -> [RepositoryModel] {
        
        let json = JSON(response);
        let totalCount = json["total_count"].int!
        var ret: [RepositoryModel] = []
        
        if totalCount != 0 {
            let items = json["items"]
            
            for (_, subJson):(String, JSON) in items {
                let fullName = subJson["full_name"].stringValue
                let description = subJson["description"].stringValue
                let htmlUrl = subJson["html_url"].stringValue
                let avatarUrl = subJson["owner"]["avatar_url"].stringValue
                
                ret.append(RepositoryModel(
                    name: fullName,
                    detail:
                    description,
                    htmlUrl: htmlUrl,
                    avatar: avatarUrl))
            }
        }
        return ret
    }
    
    fileprivate func displayErrorAlert(_ error: NSError) {
        let alert = UIAlertController(title: "Network error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertActionStyle.default,
                                      handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

