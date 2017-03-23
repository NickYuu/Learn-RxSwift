//
//  ViewController.swift
//  ReactiveLogin
//
//  Created by Tsung Han Yu on 2017/3/22.
//  Copyright © 2017年 Boxue. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var register: UIButton!
    
    var bag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.layer.borderWidth = 1
        password.layer.borderWidth = 1
        
        email.rx.text.asObservable().map { (input) -> UIColor in
                input!.isValidEmail() ? #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            }.subscribe(onNext: {
                self.email.layer.borderColor = $0.cgColor
            }).addDisposableTo(bag)
        
        password.rx.text.asObservable().map { (input) -> UIColor in
                input!.isValidPassword() ? #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            }.subscribe(onNext: {
                self.password.layer.borderColor = $0.cgColor
            }).addDisposableTo(bag)
        
        Observable.combineLatest(email.rx.text.asObservable(), password.rx.text.asObservable()) { (email, pwd) -> Bool in
                email!.isValidEmail() && pwd!.isValidPassword()
            }.bindTo(register.rx.isEnabled).addDisposableTo(bag)
        
        
    }
    
    
    
    
    
    
}
