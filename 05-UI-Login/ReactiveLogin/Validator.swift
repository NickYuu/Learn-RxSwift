//
//  Validator.swift
//  ReactiveLogin
//
//  Created by Tsung Han Yu on 2017/3/24.
//  Copyright © 2017年 Boxue. All rights reserved.
//

import Foundation

extension String {
    
    //: ### 驗證EMAIL
    func isValidEmail() -> Bool {
        let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
    
    //: ### 驗證密碼 (八個字，至少一個英文)
    func isValidPassword() -> Bool {
        let  passWordRegex = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$"
        let passWordPredicate = NSPredicate(format: "SELF MATCHES%@", passWordRegex)
        return passWordPredicate.evaluate(with: self)
    }
    
}


extension Date {
    //: ### 驗證生日是否小於今天
    func isValidDate() -> Bool {
        let calendar = Calendar.current
        let compare = (calendar as NSCalendar).compare(self, to: Date(), toUnitGranularity: .day)
        return compare == .orderedAscending
    }
}
