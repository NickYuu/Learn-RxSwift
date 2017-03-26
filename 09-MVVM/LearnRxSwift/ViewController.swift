//
//  ViewController.swift
//  LearnRxSwift
//
//  Created by Tsung Han Yu on 2017/3/21.
//  Copyright © 2017年 Tsung Han Yu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ViewController: UIViewController {
    
    fileprivate let bag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    
    typealias MySectionModel = SectionModel<String, ViewModel>
    let dataSource = RxTableViewSectionedReloadDataSource<MySectionModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.configureCell = {
            (_, tv, indexPath, element) in
            let cell =
                tv.dequeueReusableCell( withIdentifier: "cell", for: indexPath) as! TableViewCell
            
            cell.nameLabel.text = element.name.value
            cell.ageLabel.text = element.age.value
            
            return cell
        }
        
        let models = getModels()
        Observable.just(models)
            .bindTo(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(bag)
        
        tableView.rx.itemSelected
            .asObservable()
            .subscribe(onNext: {
                self.tableView.deselectRow(at: $0, animated: true)
                self.performSegue(withIdentifier: "segue", sender: models.first?.items[$0.row])
            }).addDisposableTo(bag)
        
        
        Observable.just(dataSource)
            .subscribe { [unowned self]_ in
                self.tableView.reloadData()
            }
            .addDisposableTo(bag)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let vm = sender as? ViewModel ,
              let vc = segue.destination as? SecViewController
              else {return}
        vc.viewModel = vm        
    }
    
    
    func getModels() -> [MySectionModel] {
        
        var models:[Model] = []
        for _ in 0...5 {
            models += [Model("Nick", "25"),
                       Model("Jay", "15"),
                       Model("Rex", "23"),
                       Model("Kit", "22"),]
        }
        
        var viewModel:[ViewModel] = []
        models.forEach { viewModel.append(ViewModel($0)) }
        
        
        var ret: [MySectionModel] = []
        ret.append(MySectionModel(model: "", items: viewModel))
        
        
        
        
        return ret
    }
}

