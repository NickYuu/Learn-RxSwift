//
//  ViewController.swift
//  02-RxSwift
//
//  Created by Tsung Han Yu on 2017/3/21.
//  Copyright © 2017年 Tsung Han Yu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var labek: UILabel!
    let disposebag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=ddb80380-f1b3-4f8e-8016-7ed9cba571d5")
        let request = URLRequest(url: url!)
        URLSession.shared
            .rx.response(request: request)
            .retry(3)
            .observeOn(OperationQueueScheduler(operationQueue: OperationQueue()))
            .map { (_, data) -> String in
                String(data: data, encoding: .utf8)!
        }.asObservable().bindTo(labek.rx.text).addDisposableTo(disposebag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

