//
//  AIRecipeView.swift
//  AllerBite
//
//  Created by Aditya Gaba on 8/12/24.
//

import SwiftUI

struct AIRecipieView: View {
    @State private var selectedCard: Int? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                // Enhanced Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.white.opacity(0.5), Color.white.opacity(0.7)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Header Section
                    Text("AI Recipe Generator")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.top, 0)
                        
                    
                    
                    // Allergy Free AI Recipe Generator Section
                    Text("Allergy Free AI Recipe Generator")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding(.top, 30)
                    
                    // Cards ScrollView
                    ScrollView {
                        VStack(spacing: 70) {
                            // Meal Image to Recipe Card
                            NavigationLink(destination: MealImageToRecipeView(), tag: 1, selection: $selectedCard) {
                                Card1View(title: "🍕 Meal Image to Recipe",
                                         subtitle: "Convert meal images to recipes",
                                         gradientColors: [Color.blue, Color.purple],
                                         cardImage: "photo.on.rectangle.angled")
                            }
                            
                            // Ingredient Image to Meal Card
                            NavigationLink(destination: IngredientImageToMealView(), tag: 2, selection: $selectedCard) {
                                Card1View(title: "🥕 Ingredient Image to Meal",
                                         subtitle: "Identify ingredients and suggest meals",
                                         gradientColors: [Color.green, Color.yellow],
                                         cardImage: "leaf")
                            }
                        }
                        .padding()
                    }
                }
                .padding()
            }
            .navigationTitle("AI Recipe Generator")
            .navigationBarHidden(true)
        }
//        .navigationBarBackButtonHidden()
    }
}

struct Card1View: View {
    let title: String
    let subtitle: String
    let gradientColors: [Color]
    let cardImage: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .frame(height: 220) // Adjusted height for larger cards
                .shadow(radius: 10)
                .overlay(
                    VStack {
                        HStack {
                            Image(systemName: cardImage)
                                .font(.system(size: 60)) // Larger icon size
                                .foregroundColor(.white)
                                .padding(.leading, 20)
                            Spacer()
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text(title)
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                            Text(subtitle)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding()
                    }
                )
        }
        .frame(maxWidth: .infinity) // Full width for the card
    }
}

#Preview{
    AIRecipieView()
}
