//
//  ViewController.swift
//  01-RxSwift
//
//  Created by Tsung Han Yu on 2017/3/20.
//  Copyright © 2017年 Tsung Han Yu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myTextField: UITextField!
    
    let disposebag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTextField.rx.text.asObservable().bindTo(myLabel.rx.text).addDisposableTo(disposebag)
        
        
    }

    
    @IBAction func btnClick(_ sender:UIButton) {
        myLabel.text = "1243214"
        
    }


}

