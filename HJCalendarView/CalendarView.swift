//
//  CalendarView.swift
//  Tennis
//
//  Created by Jaehyeon Park on 2021/08/14.
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, *)
struct CalendarView {
    
    @Binding var current: DateComponents?
    @Binding var calendarString: [DateComponents : String]
    
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, HJCalendarViewDelegate, HJCalendarViewDataSource {

        var parent: CalendarView
         
        init(_ parent: CalendarView) {
            
            self.parent = parent
        }

        func didChangeCalendar(_ calendarView: HJCalendarView, dateComponents: DateComponents) {

            self.parent.current = dateComponents
        }
        
        func didSelectDay(_ calendarView: HJCalendarView, indexPath: IndexPath, dateComponents:DateComponents?) {

            self.parent.current = dateComponents
        }
        
        func calendarView(_ calendarView: HJCalendarView, dateComponentsArray: [DateComponents]) -> [DateComponents:String] {

            var calendarString = [DateComponents:String]()
            
            dateComponentsArray.forEach { dateComponents in

                calendarString[dateComponents] = self.parent.calendarString[dateComponents]
            }
            
            return calendarString
            
        }

    }
    
}

@available(iOS 13.0, *)
extension CalendarView: UIViewRepresentable {

    func makeUIView(context: Context) -> UIView {
        
        let calendarView = HJCalendarView(frame: .zero)
        
        calendarView.calendarDelegate = context.coordinator
        calendarView.calendarDataSource = context.coordinator
        calendarView.setCalendarToday()

        return calendarView
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<CalendarView>) {
        
        guard let calendarView = uiView as? HJCalendarView else { return }
        
        if let year = current?.year,
           let month = current?.month {
            
            if current?.day == nil {
                DispatchQueue.main.async {
                    calendarView.setCalendar(year: year, month: month, notify: false)
                }
            }

        }
        
    }

}

#endif
