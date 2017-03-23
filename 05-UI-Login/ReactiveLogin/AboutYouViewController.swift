//
//  AboutYouViewController.swift
//  ReactiveLogin
//
//  Created by Tsung Han Yu on 2017/3/22.
//  Copyright © 2017年 Boxue. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


enum Gender {
    case notSelected
    case male
    case female
}

class AboutYouViewController: UIViewController {

    @IBOutlet weak var birthday: UIDatePicker!
    @IBOutlet weak var male: UIButton!
    @IBOutlet weak var female: UIButton!
    @IBOutlet weak var knowSwift: UISwitch!
    @IBOutlet weak var swiftLevel: UISlider!
    @IBOutlet weak var passionToLearn: UIStepper!
    @IBOutlet weak var heartHeight: NSLayoutConstraint!
    @IBOutlet weak var update: UIButton!
    
    var bag: DisposeBag! = DisposeBag()
    
    var genderSelection: Variable<Gender> = Variable<Gender>(.notSelected)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Birthday
        birthday.layer.borderWidth = 1
        birthday.rx.value.map { (date) -> UIColor in
                date.isValidDate() ? #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            }
            .subscribe(onNext: {
                self.birthday.layer.borderColor = $0.cgColor
            })
            .addDisposableTo(bag)
        
        // Gender
        male.rx.tap
            .map { Gender.male }
            .bindTo(genderSelection)
            .addDisposableTo(bag)
        
        female.rx.tap
            .map { Gender.female }
            .bindTo(genderSelection)
            .addDisposableTo(bag)
        
        genderSelection.asObservable().subscribe(onNext: {
            switch $0 {
            case .male:
                self.male.setImage(#imageLiteral(resourceName: "check"), for: .normal)
                self.female.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            case .female:
                self.male.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                self.female.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            default:
                break
            }
        }).addDisposableTo(bag)
        
        
        // Update Button
        Observable.combineLatest(birthday.rx.value.asObservable(), genderSelection.asObservable()) { (date, gender) -> Bool in
                date.isValidDate() && gender != .notSelected
            }
            .bindTo(update.rx.isEnabled).addDisposableTo(bag)
        
        // Switch
        knowSwift.rx.value.map {
                $0 ? 0.25 : 0
            }
            .bindTo(swiftLevel.rx.value)
            .addDisposableTo(bag)
        
        // Slider
        swiftLevel.rx.value.map {
                $0 != 0 ? true : false
            }
            .bindTo(knowSwift.rx.value)
            .addDisposableTo(bag)
        
        // UIStepper
        passionToLearn.rx.value.skip(1).subscribe(onNext: {
            self.heartHeight.constant = CGFloat($0 - 10)
        }).addDisposableTo(bag)
        
        
        
    }

}
