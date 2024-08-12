import SwiftUI

struct AllergyView1: View {
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
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    NavigationLink(
//                        destination: MainView().navigationBarBackButtonHidden(true),
//                        isActive: $navigateToContentView
//                    ) {
//                        Button("Done") {
//                            // Handle Done action
//                            navigateToContentView = true
//                        }
//                        .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
//                    }
//                }
//            }
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


struct AllergyView1_Previews: PreviewProvider {
    static var previews: some View {
        AllergyView1()
    }
}

