//
//  MyRxTableViewDelegateProxy.swift
//  RxNetworkDemo
//
//  Created by Tsung Han Yu on 2017/3/22.
//  Copyright © 2017年 Boxue. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

class MyRxTableViewDelegateProxy: DelegateProxy, UITableViewDelegate, DelegateProxyType {

    // 讓delegate proxy取得 “原生delegate物件” 的方法
    static func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        
        let tableView = object as! UITableView
        
        return tableView.delegate
    }
    
    // 設置delegate proxy物件的方法
    static func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        
        let tableView = object as! UITableView
        tableView.delegate = delegate as? UITableViewDelegate
        
    }
    
}

// 優雅的使用Selector
fileprivate extension Selector {
    
    static let didSelectRowAtIndexPath =
        #selector(UITableViewDelegate.tableView(_ : didSelectRowAt :))
    
    
}

extension UITableView {
    
    var rxDelegate: MyRxTableViewDelegateProxy {
        return MyRxTableViewDelegateProxy.proxyForObject(self)
    }
    var rxDidSelectRowAtIndexPath: Observable<(UITableView, IndexPath)> {
        
        return rxDelegate.methodInvoked(#selector(UITableViewDelegate.tableView(_:didSelectRowAt:)))
            .map { params in
                return (params[0] as! UITableView,
                        params[1] as! IndexPath)
        }
    }
}















