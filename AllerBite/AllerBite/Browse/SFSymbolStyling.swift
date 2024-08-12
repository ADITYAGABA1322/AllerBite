import SwiftUI

// The SFSymbolStyling view modifier modifies the styling of SF Symbols within a view.
// It sets the image scale to large and the symbol rendering mode to monochrome.
struct SFSymbolStyling: ViewModifier {
    // Modifies the body of the view with specific SF Symbol styling attributes.
    func body(content: Content) -> some View {
        content
            .imageScale(.large)  // Sets the image scale to large
            .symbolRenderingMode(.monochrome)  // Sets the symbol rendering mode to monochrome
    }
}

// Extension on View to provide a convenient method for applying SF Symbol styling.
extension View {
    // Applies the SFSymbolStyling modifier to the view, modifying SF Symbols within it.
    func sfSymbolStyling() -> some View {
        modifier(SFSymbolStyling())  // Adds the SFSymbolStyling modifier to the view
    }
}

