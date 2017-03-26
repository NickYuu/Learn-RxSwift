//: Playground - noun: a place where people can play

import Cocoa
import RxSwift
import RxCocoa
/*
//: ### Empty
//  唯一可以做的事情，就是向订阅者发送一个Completed事件。
print("--- Empty ---")
let enptySequence = Observable<Int>.empty()
enptySequence.subscribe {
    even in
    print(even)
}

//: ### Just
//  创建的事件序列只包含一个事件元素，当订阅它的时候，它向订阅者发送两个消息：事件值和.Completed事件。
print("--- Just sequence ---")
_ = Observable<String>.just("TsungHan").subscribe {
    even in
    print(even)
}

//: ### Of
//  创建一个可以向observer发送固定个数事件的序列，发送完成之后，发送.Completed
print("--- Of sequence ---")
_ = Observable<Int>.of(0,1,2,3,4,5,6,7,8,9).subscribe {
    (even:Event<Int>) -> Void in
    print(even)
}

//: ### error
//  用于定义一个只能订阅.Error事件的序列
print("--- error example ---")
let err = NSError(domain: "Test", code: -1, userInfo: nil)
Observable<Int>.error(err).subscribe {
    even in
    print(even)
}

//: ### create
//  允许我们使用Swift closure自定义一个事件序列的构建过程。例如，我们根据事件的值是否是偶数自定义一个事件序列
print("--- create ---")
func myJust(_ event:Int) -> Observable<Int> {
    return Observable.create({ (observer) -> Disposable in
        if event % 2 == 0 {
            observer.on(.next(event))
            observer.on(.completed)
        }
        else {
            let err = NSError(domain: "Not an even number", code: 401, userInfo: nil)
            observer.on(.error(err))
        }
        return Disposables.create()
    })
}

myJust(10).subscribe { print($0) }
myJust(5).subscribe { print($0) }

//: ### generate - 用prev决定next的事件序列
//  generate可以生成一连串事件，并且，允许我们根据上一次事件的结果生成下一次事件，并设置.Completed条件：
//
//  initialState    用于指定事件序列的初始值，它是一个.Next(0)；
//  condition       是一个closure，当它为true时，就生成.Next，否则生成.Completed；
//  iterator        用于设置每一次发送事件之后，对事件值进行的迭代操作，在我们的例子里，就是.Next的值加1；
_ = Observable.generate(initialState: 0,
                        condition   : { $0 < 10 },
                        iterate     : { $0 + 1}
                        ).subscribe {
                            print($0)
                        }

//: ### deferred - 只有在被订阅后才创建并产生事件的序列

//  与其说deferred用于创建一个事件序列，不如说它是对创建序列的一种修饰。被deferred修饰后，事件序列只有在被订阅时才生成，并发送事件，并且，每订阅一次，就新生成一个事件序列对象。

let deferredSequence = Observable.deferred { () -> Observable<Int> in
    print("generating")
    
    return Observable.generate(initialState: 0, condition: { $0 < 3 }, iterate: { $0 + 1 })
}

deferredSequence.subscribe { print($0) }
deferredSequence.subscribe { print($0) }

*/


//var masterNo        =  Variable("")     // 指定老師編號
//var masterGendar    =  Variable("")    // 老師性別
//var specifyGendar   =  Variable("")    // 不指定老師，但指定性別
//
//
//
//
//Observable.combineLatest( masterNo.asObservable(),
//                          masterGendar.asObservable(),
//                          specifyGendar.asObservable())
//    { (no, gender, spec) -> String in
//        if !no.isEmpty { return no + gender }
//        else if !spec.isEmpty { return gender}
//        return "不指定"
//    }
//    .skip(1)
//    .subscribe { (event) in
//        print(event.element!)
//    }
//
//
//masterNo.value = "123"
//masterGendar.value = "男"
//specifyGendar.value = ""



