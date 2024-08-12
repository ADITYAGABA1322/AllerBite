import SwiftUI

struct AllergyView: View {
    private var listOfAllergies = allergyData
    @State private var searchText = ""
    @State private var navigateToContentView = false
    @State private var navigateToMainView = false
    @State private var selectedAllergies: Set<String> = []

    var body: some View {
        NavigationView {
            List {
                ForEach(allergies, id: \.self) { allergy in
                    AllergyRow(allergy: allergy, isSelected: selectedAllergies.contains(allergy.name), selectedAllergies: $selectedAllergies)
                        .padding()
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Choose Your Allergy")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(
                        destination: MainView().navigationBarBackButtonHidden(true),
                        isActive: $navigateToContentView
                    ) {
                        Button("Done") {
                            // Handle Done action
                            navigateToContentView = true
                        }
                        .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
                    }
                }
            }
        }
        .onAppear(perform: loadSavedAllergies)
     
    }
    

    private func loadSavedAllergies() {
        if let savedAllergies = UserDefaults.standard.array(forKey: "savedAllergies") as? [String] {
            print("Loaded saved allergies:", savedAllergies)
            self.selectedAllergies = Set(savedAllergies)
        }
    }

    // Filter allergies
    var allergies: [Allergy] {
        // Make allergies lowercased
        let lcAllergies = listOfAllergies.map { Allergy(symbol: $0.symbol.lowercased(), name: $0.name.lowercased()) }

        return searchText.isEmpty ? lcAllergies : lcAllergies.filter { $0.name.contains(searchText.lowercased()) }
    }
}

struct Allergy: Identifiable, Hashable {
    let id = UUID() // Use UUID for unique identifiers
    var symbol: String
    var name: String
}

struct AllergyRow: View {
    let allergy: Allergy
    let isSelected: Bool
    @Binding var selectedAllergies: Set<String> // Use binding to update selectedAllergies
    
    var body: some View {
        HStack {
            Text(allergy.symbol)
                .font(.title)
            Text(allergy.name)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
            }
        }
        .padding(.vertical, -5)
        .contentShape(Rectangle()) // Make the entire row tappable
        .onTapGesture {
            if isSelected {
                selectedAllergies.remove(allergy.name)
            } else {
                selectedAllergies.insert(allergy.name)
            }
            saveSelectedAllergies() // Call the saveSelectedAllergies function
        }
    }

    private func saveSelectedAllergies() {
        UserDefaults.standard.set(Array(selectedAllergies), forKey: "savedAllergies")
    }
}

// Sample allergy data (replace with your actual data)
let allergyData = [
    Allergy(symbol: "🥜", name: "Peanut"),
    Allergy(symbol: "🥚", name: "Egg"),
    Allergy(symbol: "🥛", name: "Milk"),
    Allergy(symbol: "🫘", name: "Kidney Beans"),
    Allergy(symbol: "🐟", name: "Fish and Shelfish"),
    Allergy(symbol: "🌴", name: "Palm Oil"),
    Allergy(symbol: "🥑", name: "Avocado"),
    Allergy(symbol: "🌾", name: "Wheat"),
    Allergy(symbol: "🦀", name: "Crustaceans")
]

struct AllergyView_Previews: PreviewProvider {
    static var previews: some View {
        AllergyView()
    }
}
