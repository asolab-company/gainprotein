import Foundation

// MARK: - Enums


enum ActivityLevel: String, CaseIterable, Codable, CustomStringConvertible {
    case sedentary = "Sedentary"
    case light = "Light Activity"
    case moderate = "Moderate Activity"
    case high = "High Activity"
    case athlete = "Athlete"
    
    var adjustment: Double {
        switch self {
        case .sedentary: return 0.0
        case .light: return 0.1
        case .moderate: return 0.2
        case .high: return 0.3
        case .athlete: return 0.4
        }
    }
    
    var description: String { rawValue }
}

enum Goal: String, CaseIterable, Codable, CustomStringConvertible {
    case weightLoss = "Weight Loss"
    case maintenance = "Maintenance"
    case muscleGain = "Muscle Gain"
    
    var factor: Double {
        switch self {
        case .weightLoss: return 1.2
        case .maintenance: return 1.4
        case .muscleGain: return 1.8
        }
    }
    
    var description: String { rawValue }
}

enum UnitSystem: String, CaseIterable, Codable, CustomStringConvertible {
    case metric = "Metric (kg, g)"
    case imperial = "Imperial (lbs, oz)"
    
    var description: String { rawValue }
}

// MARK: - Models

struct ProteinInputData: Codable {
    var weight: Double
    var age: Int
    var activity: ActivityLevel
    var goal: Goal
    var unitSystem: UnitSystem
}

struct SavedProfile: Identifiable, Codable {
    var id = UUID()
    var name: String
    var input: ProteinInputData
    var calculatedProtein: Double
    var date: Date = Date()
}

// MARK: - Logic

struct ProteinCalculator {

    static func calculateProteinFactor(input: ProteinInputData) -> Double {
        let ageAdjustment: Double
        if input.age < 30 {
            ageAdjustment = 0.0
        } else if input.age <= 50 {
            ageAdjustment = 0.05
        } else {
            ageAdjustment = 0.1
        }
        
        return input.goal.factor + input.activity.adjustment + ageAdjustment
    }
    
    static func calculateDailyProtein(input: ProteinInputData) -> Double {
        let weightInKg: Double
        if input.unitSystem == .imperial {
            weightInKg = input.weight * 0.453592
        } else {
            weightInKg = input.weight
        }
        
        let factor = calculateProteinFactor(input: input)
        return weightInKg * factor
    }
}
