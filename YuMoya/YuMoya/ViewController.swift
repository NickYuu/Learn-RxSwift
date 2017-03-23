//
//  ViewController.swift
//  YuMoya
//
//  Created by Tsung Han Yu on 2017/3/20.
//  Copyright © 2017年 Tsung Han Yu. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userBtn: UIButton!
    @IBOutlet weak var repoBtn: UIButton!
    @IBOutlet weak var searchField: UITextField!
    
    let viewModel = GitHubViewModel()
    let bag = DisposeBag()
    var models: [GitHubModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userBtn.rx.tap
            .map { [unowned self] in
                self.searchField.text!
            }
            .flatMap {
                self.viewModel.getUserRepositories($0)
            }
            .subscribe(onNext: { (models) in
                self.models = models
                self.tableView.reloadData()
            }, onError: { (error) in
                print(error)
            })
            .addDisposableTo(bag)
        
        repoBtn.rx.tap
            .map { [unowned self] in
                self.searchField.text!
            }
            .flatMap {
                self.viewModel.getRepositories($0)
            }.subscribe(onNext: { (models) in
                self.models = models
                self.tableView.reloadData()
            }, onError: { (error) in
                print(error)
            }).addDisposableTo(bag)
        
        viewModel.getRepositories("RxSwift")
            .subscribe({ [unowned self] event in
                switch event {
                case .next(let models):
                    self.models = models
                    self.tableView.reloadData()
                case .error(let error):
                    print(error)
                case .completed:
                    return
                }
            })
            .addDisposableTo(bag)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow,
            let urlStr = models[indexPath.row].html_url
            else { return }
        guard let vc = segue.destination as? WebViewController
            else { return }
        vc.urlStr = urlStr
    }
    
    
}


// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let model = models[indexPath.row]
        cell.textLabel?.text = model.name
        cell.detailTextLabel?.text = ""
        if let star = model.stargazers_count {
            cell.detailTextLabel?.text = "🌟: \(star)"
        }
        
        
        return cell
    }
}


// MARK: - Alert Helper
extension ViewController {
    
    fileprivate func showAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(ok)
        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func textFieldAlert(_ title: String, btmTitle: String = "OK", handler: @escaping (_ text:String)->()) {
        var usernameTextField: UITextField?
        
        let promptController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: btmTitle, style: .default) { action in
            if let username = usernameTextField?.text {
                handler(username)
            }
        }
        promptController.addAction(ok)
        promptController.addTextField { textField in
            usernameTextField = textField
        }
        present(promptController, animated: true, completion: nil)
    }
}


