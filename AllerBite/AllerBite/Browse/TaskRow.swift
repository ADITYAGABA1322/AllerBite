import SwiftUI

// The TaskRow view represents a row for displaying or editing an event task.
struct TaskRow: View {
    @Binding var task: EventTask  // Binding to the task object
    var isEditing: Bool  // Flag to indicate if editing mode is active
    @FocusState private var isFocused: Bool  // Focus state to track text field focus

    var body: some View {
        HStack {
            Button {
                task.isCompleted.toggle()  // Toggle task completion status
            } label: {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")  // Display checkmark if completed
            }
            .buttonStyle(.plain)

            if isEditing || task.isNew {
                // Display editable text field for task description
                TextField("Task description", text: $task.text)
                    .focused($isFocused)
                    .onChange(of: isFocused) { newValue in
                        if newValue == false {
                            task.isNew = false  // Update isNew flag when focus is lost
                        }
                    }

            } else {
                Text(task.text)  // Display task description text
            }

            Spacer()  // Spacer to push content to the right
        }
        .padding(.vertical, 10)  // Apply vertical padding
        .task {
            if task.isNew {
                isFocused = true  // Set focus on new task
            }
        }
    }
}

// Preview for the TaskRow view
struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
        TaskRow(task: .constant(EventTask(text: "Do something!")), isEditing: false)  // Preview with example task
    }
}

