//
//  Calendar.swift
//  Tidsoptimisten
//
//  Created by Halfdan Albrecht Isaksen on 21/02/2024.
import SwiftUI

struct CustomCalendar: UIViewRepresentable {
    let interval: DateInterval
    var tasks: [OverTask]
    @Binding var selectedDate: Date?
    
    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        calendarView.calendar = Calendar(identifier: .gregorian)
        calendarView.calendar.timeZone = TimeZone.current
        calendarView.availableDateRange = interval
        
        // Set the delegate for decorations if needed
        // calendarView.delegate = context.coordinator
        
        // Create and set the date selection behavior
        let dateSelection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        calendarView.selectionBehavior = dateSelection
        
        return calendarView
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        // Update the view if necessary
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UICalendarSelectionSingleDateDelegate {
        var parent: CustomCalendar

        init(_ parent: CustomCalendar) {
            self.parent = parent
        }
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {

            if let dateComponents = dateComponents {
                // Use the calendar with the current time zone to create the date
                let calendar = Calendar.current
                if let date = calendar.date(from: dateComponents) {
                    // Use the startOfDay to get the beginning of the day for the selected date in the correct time zone
                    let startOfDay = calendar.startOfDay(for: date)

                    // Adjust for the time zone offset
                    let timeZoneOffset = TimeInterval(TimeZone.current.secondsFromGMT(for: startOfDay))
                    let localDate = startOfDay.addingTimeInterval(timeZoneOffset)

                    parent.selectedDate = localDate
                }
            }
        }

    }
}


