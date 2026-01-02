import SwiftUI
import Combine

class CalculatorViewModel: ObservableObject {
    // Inputs
    @Published var weightString: String = ""
    @Published var ageString: String = ""

    @Published var activity: ActivityLevel? = nil
    @Published var goal: Goal? = nil
    @Published var unitSystem: UnitSystem? = nil
    
    @Published var profileName: String = ""
    
    var isFormValid: Bool {
        return !weightString.isEmpty &&
               !ageString.isEmpty &&
               activity != nil &&
               goal != nil &&
               unitSystem != nil &&
               !profileName.isEmpty
    }
    
    // Outputs
    @Published var resultProtein: Double? = nil
    @Published var resultFactor: Double? = nil
    
    // Storage
    @Published var savedProfiles: [SavedProfile] = [] {
        didSet {
            saveToDisk()
        }
    }
    
    private let saveKey = "SavedProfiles"
    
    init() {
        loadProfiles()
    }
    
    func calculate() {
        guard let weight = Double(weightString),
              let age = Int(ageString),
              let activity = activity,
              let goal = goal,
              let unitSystem = unitSystem else {
            return
        }
        
        let input = ProteinInputData(
            weight: weight,
            age: age,
            activity: activity,
            goal: goal,
            unitSystem: unitSystem
        )
        
        resultFactor = ProteinCalculator.calculateProteinFactor(input: input)
        resultProtein = ProteinCalculator.calculateDailyProtein(input: input)
    }
    
    func saveProfile() {
        guard let protein = resultProtein, 
              let weight = Double(weightString),
              let age = Int(ageString),
              !profileName.isEmpty,
              let activity = activity,
              let goal = goal,
              let unitSystem = unitSystem else { return }
        
        let input = ProteinInputData(
            weight: weight,
            age: age,
            activity: activity,
            goal: goal,
            unitSystem: unitSystem
        )
        
        let profile = SavedProfile(
            name: profileName,
            input: input,
            calculatedProtein: protein
        )
        
        savedProfiles.append(profile)
        
        // Reset inputs and result
        profileName = ""
        weightString = ""
        ageString = ""

        self.activity = nil
        self.goal = nil
        self.unitSystem = nil
        resultProtein = nil
        resultFactor = nil
    }
    
    func deleteProfile(at offsets: IndexSet) {
        savedProfiles.remove(atOffsets: offsets)
    }
    
    private func saveToDisk() {
        if let encoded = try? JSONEncoder().encode(savedProfiles) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    func loadProfiles() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([SavedProfile].self, from: data) {
            savedProfiles = decoded
        }
    }
    
    func resetCalculation() {
        resultProtein = nil
        resultFactor = nil
    }
}
