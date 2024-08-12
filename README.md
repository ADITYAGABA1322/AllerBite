# AllerBite - Your Personalized Food Companion

#### Welcome to AllerBite, a powerful iOS app built using SwiftUI to help you manage your food preferences, allergies, and discover new recipes tailored to your dietary needs.

# Most Important Note
 # 1.) Add your Gemini API Key in GenerativeAI-Info.plist File
 # 2.) Add your  GoogleService-Info.plist for Google Authenticator and Firebase usage
 # 3.) Create Your Info plist for storing the  URL type for  gogole sign in  reversed Client id
Prerequisites:

# Technologies Used

### SwiftUI:
The entire app is built using SwiftUI, Apple's modern framework for building user interfaces across all Apple platforms.

### VisionKit: 
Utilizes VisionKit to power the scanner screen, allowing users to scan food labels and extract relevant information.

### Gemini: 
Gemini Technology Overview
Gemini is a powerful API that leverages machine learning and advanced data analytics to provide real-time insights and predictions. It is particularly useful in applications that require detailed analysis of complex data sets, such as food ingredient analysis for allergen detection.

How to Use Gemini in AllerBite
1. Ingredient Analysis:

Purpose: Use Gemini to analyze food ingredients and detect potential allergens.
Implementation:
When a user scans a food product, send the ingredient list to the Gemini API.
The API will analyze the ingredients and return information about potential allergens.
Display the results to the user, highlighting any allergens detected.


2. Recipe Generation:

Purpose: Generate allergen-free recipes based on user preferences and dietary restrictions.
Implementation:
Collect user preferences (e.g., allergies, dietary restrictions) and send them to the Gemini API.
The API will generate a list of recipes that are safe for the user to consume.
Display the recipes along with detailed ingredient lists and preparation instructions.


3. Real-Time Alerts:

Purpose: Provide real-time alerts about potential allergens in food products.
Implementation:
Integrate Gemini's real-time data capabilities to monitor food products and ingredients.
When a user is about to consume a product, the app can send a request to Gemini for a real-time analysis.
If any allergens are detected, the app will alert the user immediately.

### Combine Framework:
Utilizes Combine for reactive programming and handling asynchronous events, enhancing app responsiveness.


# Key Screens

## Home Screen

1.) The central hub where users can access various app features and navigate to different sections.

2.) Displays personalized content, such as recommended recipes and allergy alerts.

## Browse Screen

1.) Allows users to browse through a curated collection of recipes based on their dietary preferences and restrictions.

2.) Includes filters for different cuisines, dietary requirements, and allergen-free recipes.

## Login Screen

1.) Secure authentication system for users to log in or create an account

2.) Enables personalized features and data syncing across devices.

## Scanner Screen

1.) Integrates VisionKit to scan food labels and ingredients.

2.) Provides real-time allergy detection and alerts users about potential allergens in scanned products.

## Allergy Management

1.) Users can input their food allergies, sensitivities, and dietary restrictions.

2.) Utilizes machine learning models powered by Core ML to predict potential allergic reactions and suggest safe alternatives.

## Features

### Personalized Recommendations: 
Tailored recipe suggestions based on user preferences and dietary needs.

### Allergy Detection: 
 Real-time allergy detection using machine learning algorithms to ensure food safety.

### Recipe Filtering:
Filter recipes based on dietary requirements, allergens, and cuisine preferences.

### Data Syncing:
Seamless synchronization of user data across devices for a consistent experience.

### User-Friendly Interface:
Intuitive UI design with smooth animations and interactions for enhanced user experience.

# Getting Started

1.) Clone the repository to your local machine

2.) Open the project in Xcode

3.) Build and run the app on a simulator or device

#### If you have any feedback, suggestions, or encounter any issues, please feel free to open an issue on GitHub.

# Thank you for using AllerBite!
