import SwiftUI

struct ProfileView: View {
    var body: some View {
        List {
            // Icon at the top of the list
            

                   
            HStack {
                Spacer()
                Image("profile") 
                Spacer()
                
                
            }
            .listRowBackground(Color.clear) // Ensures the background of this specific row is clear

            // Health Details Section
            Section() {
                NavigationLink(destination: HealthView()) {
                    Text("Health Details")
                }
                
                NavigationLink(destination: HealthView()) {
                    Text("Medical ID")
                }
                // Add more health details as needed
            }
            
            Section(header:
                                Text("Features")
                                .foregroundColor(.black)
                                .font(.system(size: 20).bold())
                                .textCase(.none)  // Make first letter capital, rest small
                .offset(x:-19)
                    ) {
                        NavigationLink(destination: HealthView()) {
                            Text("Subscriptions")
                        }
                        NavigationLink(destination: HealthView()) {
                            Text("Notifications")
                        }
                    }

          
            // Medical ID Section
            Section(header: Text("Privacy")
                .foregroundColor(.black)
                .font(.system(size: 20).bold())
                .textCase(.none)
                .offset(x:-19)) {
                NavigationLink(destination: HealthView()) {
                    Text("Apps and Services")
                }
                NavigationLink(destination: HealthView()) {
                    Text("Research Studies")
                }
                NavigationLink(destination: HealthView()) {
                    Text("Devices")
                }
            }
         
        }
        .listStyle(InsetGroupedListStyle())
    }
    
}

struct HealthView: View {
    var body: some View {
        Text("Health Details View")
            .navigationBarTitle("Health Details")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView()
        }
    }
}

