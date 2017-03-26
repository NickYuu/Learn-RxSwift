//
//  ViewModel.swift
//  LearnRxSwift
//
//  Created by Tsung Han Yu on 2017/3/25.
//  Copyright © 2017年 Tsung Han Yu. All rights reserved.
//

import RxSwift

class ViewModel {
    
    fileprivate let bag = DisposeBag()
    
    private var model: Model
    
    var name:Variable<String?> = Variable(String())
    var age:Variable<String?> = Variable(String())
    
    init(_ model:Model) {
        self.model = model
        name.value = model.name
        age.value = model.age
        
        name
            .asObservable()
            .subscribe(onNext: { [unowned self] in
                self.model.name = $0!
            })
            .addDisposableTo(bag)
        
        age
            .asObservable()
            .subscribe(onNext: { [unowned self] in
                self.model.age = $0!
            })
            .addDisposableTo(bag)
        
    }
    
}
