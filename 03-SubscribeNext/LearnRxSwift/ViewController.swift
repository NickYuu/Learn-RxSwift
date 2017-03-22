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

class ViewController: UIViewController {
    
    @IBOutlet weak var rxUserInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = rxUserInput.rx.text.asObservable().map {  input -> Int in
            if let lastChar = input?.characters.last {
                if let n = Int(String(lastChar)) {
                    return n
                }
            }
            return -1
        }
        .filter { $0 % 2 == 0 }
        .subscribe { print($0.element ?? -1) }
    }


}

