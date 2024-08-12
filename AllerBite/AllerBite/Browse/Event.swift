import SwiftUI

// The Event struct represents an event with various properties like id, symbol, color, title, tasks, and date.
// It also includes computed properties to determine task completion status and date comparisons.
struct Event: Identifiable, Hashable {
    var id = UUID()  // Unique identifier for each event
    var symbol: String = EventSymbols.randomName()  // Randomly generated symbol for the event
    var color: Color = ColorOptions.random()  // Random color for the event
    var title = ""  // Title of the event
    var tasks = [EventTask(text: "")]  // Tasks associated with the event
    var date = Date()  // Date of the event
    
    // Computed property to calculate the remaining number of tasks
    var remainingTaskCount: Int {
        tasks.filter { !$0.isCompleted }.count
    }
    
    // Computed property to check if all tasks are completed
    var isComplete: Bool {
        tasks.allSatisfy { $0.isCompleted }
    }
    
    // Computed property to check if the event is in the past
    var isPast: Bool {
        date < Date.now
    }
    
    // Computed property to check if the event is within the next seven days
    var isWithinSevenDays: Bool {
        !isPast && date < Date.now.sevenDaysOut
    }
    
    // Computed property to check if the event is within seven to thirty days
    var isWithinSevenToThirtyDays: Bool {
        !isPast && !isWithinSevenDays && date < Date.now.thirtyDaysOut
    }
    
    // Computed property to check if the event is distant (more than thirty days away)
    var isDistant: Bool {
        date >= Date().thirtyDaysOut
    }

    // Example event data for testing purposes
    static var example = Event(
        symbol: "case.fill",
        title: "Sayulita Trip",
        tasks: [
            EventTask(text: "Buy plane tickets"),
            EventTask(text: "Get a new bathing suit"),
            EventTask(text: "Find an airbnb"),
        ],
        date: Date(timeIntervalSinceNow: 60 * 60 * 24 * 365 * 1.5))
}

// Extension to Date providing convenience methods for calculating dates in the future
extension Date {
    var sevenDaysOut: Date {
        Calendar.autoupdatingCurrent.date(byAdding: .day, value: 7, to: self) ?? self
    }
    
    var thirtyDaysOut: Date {
        Calendar.autoupdatingCurrent.date(byAdding: .day, value: 30, to: self) ?? self
    }
}

