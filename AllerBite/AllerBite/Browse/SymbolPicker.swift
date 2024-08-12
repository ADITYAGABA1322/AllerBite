import SwiftUI

// The SymbolPicker view allows the user to pick a symbol and color for an event.
struct SymbolPicker: View {
    @Binding var event: Event  // Binding to the event object
    @State private var selectedColor: Color = ColorOptions.default  // State to track the selected color
    @Environment(\.dismiss) private var dismiss  // Environment value to dismiss the view
    @State private var symbolNames = EventSymbols.symbolNames  // State to track symbol names
    @State private var searchInput = ""  // State to track search input
    
    var columns = Array(repeating: GridItem(.flexible()), count: 6)  // Grid columns for symbol grid

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    dismiss()  // Button to dismiss the view
                } label: {
                    Text("Done")  // Label for the Done button
                }
                .padding()
            }
            HStack {
                Image(systemName: event.symbol)  // Display the event symbol
                    .font(.title)
                    .imageScale(.large)
                    .foregroundColor(selectedColor)

            }
            .padding()

            HStack {
                // Display color circles for color selection
                ForEach(ColorOptions.all, id: \.self) { color in
                    Button {
                        selectedColor = color  // Set selected color
                        event.color = color  // Update event color
                    } label: {
                        Circle()
                            .foregroundColor(color)
                    }
                }
            }
            .padding(.horizontal)
            .frame(height: 40)

            Divider()

            // Display symbol picker grid
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(symbolNames, id: \.self) { symbolItem in
                        Button {
                            event.symbol = symbolItem  // Update event symbol
                        } label: {
                            Image(systemName: symbolItem)
                                .sfSymbolStyling()  // Apply SF Symbol styling
                                .foregroundColor(selectedColor)
                                .padding(5)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .drawingGroup()
            }
        }
        .onAppear {
            selectedColor = event.color  // Set selected color initially
        }
    }
}

// Preview for the SymbolPicker view
struct SFSymbolBrowser_Previews: PreviewProvider {
    static var previews: some View {
        SymbolPicker(event: .constant(Event.example))  // Preview with example event
    }
}

