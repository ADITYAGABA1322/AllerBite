import SwiftUI

struct DetailView: View {
    var isSafeToEat: Bool
    
    var body: some View {
        VStack {
            if isSafeToEat {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                    .padding()
                Text("Safe to Eat")
                    .font(.title)
                    .foregroundColor(.green)
            } else {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.red)
                    .padding()
                Text("Not Safe to Eat")
                    .font(.title)
                    .foregroundColor(.red)
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    DetailView(isSafeToEat: true)
}

