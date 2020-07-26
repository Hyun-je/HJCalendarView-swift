//
//  HJCalendar+Rx.swift
//  Tennis
//
//  Created by JaehyeonPark on 2020/07/26.
//  Copyright © 2020 Jae-Hyeon-Park. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class RxHJCalendarViewDelegateProxy: DelegateProxy<HJCalendarView, HJCalendarViewDelegate>, DelegateProxyType, HJCalendarViewDelegate {
    
    static func registerKnownImplementations() {
        self.register { (calendarView) -> RxHJCalendarViewDelegateProxy in
            RxHJCalendarViewDelegateProxy(parentObject: calendarView, delegateProxy: self)
        }
    }
    
    
    static func currentDelegate(for object: HJCalendarView) -> HJCalendarViewDelegate? {
        return object.calendarDelegate
    }
    
    static func setCurrentDelegate(_ delegate: HJCalendarViewDelegate?, to object: HJCalendarView) {
        object.calendarDelegate = delegate
    }
    
}


extension Reactive where Base: HJCalendarView {
    
    var calendarDelegate: DelegateProxy<HJCalendarView, HJCalendarViewDelegate> {
        return RxHJCalendarViewDelegateProxy.proxy(for: self.base)
    }
    
    var didChangeCalendar: Observable<DateComponents?> {
        return calendarDelegate.methodInvoked(#selector(HJCalendarViewDelegate.didChangeCalendar(_:dateComponents:)))
            .map{ parameters in
                return parameters[1] as? DateComponents
            }
    }
    
    var didSelectDay: Observable<DateComponents?> {
        return calendarDelegate.methodInvoked(#selector(HJCalendarViewDelegate.didSelectDay(_:indexPath:dateComponents:)))
            .map{ parameter in
                return parameter[2] as? DateComponents
            }
    }

}
