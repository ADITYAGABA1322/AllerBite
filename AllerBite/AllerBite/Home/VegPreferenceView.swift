//
//  VegPreferenceView.swift
//  AllerBite
//
//  Created by Aditya Gaba on 8/12/24.
//

import SwiftUI

struct VegPreferenceView: View {
    @State private var isVegetarian: Bool = false
    @State private var isNonVegetarian: Bool = false

    var body: some View {
        VStack {
            Text("🥦 Dietary Preferences")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)

            Text("Select your dietary preference")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.bottom, 20)

            Toggle(isOn: $isVegetarian) {
                Text("Vegetarian")
                    .font(.title2)
            }
            .padding()

            Toggle(isOn: $isNonVegetarian) {
                Text("Non-Vegetarian")
                    .font(.title2)
            }
            .padding()

            Spacer()

            Button(action: savePreferences) {
                Text("Save Preferences")
                    .frame(maxWidth: .infinity)
                    .bold()
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
            }
            .padding(.horizontal)
            .offset(y:-20)
        }
        .padding(.horizontal)
    }

    func savePreferences() {
        // Save preferences logic here
        print("Vegetarian: \(isVegetarian), Non-Vegetarian: \(isNonVegetarian)")
    }
}

struct VegPreferenceView_Previews: PreviewProvider {
    static var previews: some View {
        VegPreferenceView()
    }
}
