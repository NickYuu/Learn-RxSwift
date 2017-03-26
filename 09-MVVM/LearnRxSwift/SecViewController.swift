//
//  SecViewController.swift
//  LearnRxSwift
//
//  Created by Tsung Han Yu on 2017/3/26.
//  Copyright © 2017年 Tsung Han Yu. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SecViewController: UIViewController {
    
    
    fileprivate let bag = DisposeBag()
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    
    var viewModel:ViewModel? {
        didSet {
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRX()
        
    }
    
    
    func setRX() {
        guard let viewModel = viewModel else { return }
        
        viewModel.name
            .asObservable()
            .bindTo(nameField.rx.text)
            .addDisposableTo(bag)
        
        viewModel.age
            .asObservable()
            .bindTo(ageField.rx.text)
            .addDisposableTo(bag)
        
        nameField.rx.text
            .asObservable()
            .bindTo(viewModel.name)
            .addDisposableTo(bag)
        
        ageField.rx.text
            .asObservable()
            .bindTo(viewModel.age)
            .addDisposableTo(bag)
    }
    
    
}
