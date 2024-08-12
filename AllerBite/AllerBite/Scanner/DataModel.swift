import Foundation

// UserModel.swift

class User {
    var username: String
    var age: Int
    
    init(username: String, age: Int) {
        self.username = username
        self.age = age
       
    }
}



// HomeScreenModel.swift

class HomeScreenPreferences {
    var allergenPreference: Bool // true for allergen-free, false otherwise
    var foodPreference: FoodType
    
    init(allergenPreference: Bool, foodPreference: FoodType) {
        self.allergenPreference = allergenPreference
        self.foodPreference = foodPreference
    }
}

enum FoodType {
    case vegetarian
    case nonVegetarian
    case healthConscious
}


struct ProductNamespace {
    class Ingredient {
        var name: String
        var isAllergen: Bool
        
        init(name: String, isAllergen: Bool) {
            self.name = name
            self.isAllergen = isAllergen
        }
    }
}

//class ScannerData {
//    var productName: String
//    var ingredients: [ProductNamespace.Ingredient]
//
//    init(productName: String, ingredients: [ProductNamespace.Ingredient]) {
//        self.productName = productName
//        self.ingredients = ingredients
//    }
//}


// Another view for home screen

class HomeViewModel {
    var userPreferences: HomeScreenPreferences
    
    init(userPreferences: HomeScreenPreferences) {
        self.userPreferences = userPreferences
    }
    
    func checkProductCompatibility(product: ScannerData) -> Bool {
        // Check if the product meets the user's preferences
        let isAllergenFree = !product.ingredients.contains { $0.isAllergen }
        let isFoodTypeCompatible = isCompatibleFoodType(foodType: product.foodType)
        
        return isAllergenFree && isFoodTypeCompatible
    }
    
    private func isCompatibleFoodType(foodType: FoodType) -> Bool {
        switch userPreferences.foodPreference {
        case .vegetarian:
            return foodType == .vegetarian || foodType == .healthConscious
        case .nonVegetarian:
            return foodType == .nonVegetarian || foodType == .healthConscious
        case .healthConscious:
            return true
        }
    }
}



// scanner view model

class ScannerData {
    var productName: String
    var ingredients: [ProductNamespace.Ingredient]
    var foodType: FoodType // Add foodType property
    
    init(productName: String, ingredients: [ProductNamespace.Ingredient], foodType: FoodType) {
        self.productName = productName
        self.ingredients = ingredients
        self.foodType = foodType // Initialize foodType property
    }
}


// HealthPlannerModel.swift

class HealthPlannerData {
    var appointments: [Appointment]
    var medicines: [Medicine]
    var allergenReactions: [AllergenReaction]
    
    init(appointments: [Appointment], medicines: [Medicine], allergenReactions: [AllergenReaction]) {
        self.appointments = appointments
        self.medicines = medicines
        self.allergenReactions = allergenReactions
    }
}

class Appointment {
    var appointmentDate: Date
    var doctor: Doctor
    
    init(appointmentDate: Date, doctor: Doctor) {
        self.appointmentDate = appointmentDate
        self.doctor = doctor
    }
}

class Doctor {
    var name: String
    var specialty: String
    
    init(name: String, specialty: String) {
        self.name = name
        self.specialty = specialty
    }
}

class Medicine {
    var name: String
    var dosage: String
    
    init(name: String, dosage: String) {
        self.name = name
        self.dosage = dosage
    }
}

class AllergenReaction {
    var allergen: Allergen
    var reactionDescription: String
    
    init(allergen: Allergen, reactionDescription: String) {
        self.allergen = allergen
        self.reactionDescription = reactionDescription
    }
}

class Allergen {
    var name: String
    var severity: AllergySeverity
    
    init(name: String, severity: AllergySeverity) {
        self.name = name
        self.severity = severity
    }
}

enum AllergySeverity {
    case mild
    case moderate
    case severe
}

