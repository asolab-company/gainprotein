import SwiftUI
import Combine
import FirebaseCore
import FirebaseDatabase

final class LegalStore: ObservableObject {
    @Published var privacyPolicy: String = ""
    @Published var termsAndConditions: String = ""
    @Published var isLoading: Bool = false
    
    // Data will be fetched from Firebase
    
    init() {
        self.privacyPolicy = ""
        self.termsAndConditions = ""
    }
    
    func fetchLegalTexts() {
        guard let _ = FirebaseApp.app() else {
            print("Firebase not configured yet.")
            return
        }
        
        isLoading = true
        let ref = Database.database().reference()
        
        // Fetch Policy: Text/policy
        ref.child("Text/policy").observe(.value, with: { [weak self] snapshot in
            // Safe helper to get string from any value (String or Int)
            var fetchedText = ""
            if let stringVal = snapshot.value as? String {
                fetchedText = stringVal
            } else if let numberVal = snapshot.value as? NSNumber {
                fetchedText = numberVal.stringValue
            }
            
            if !fetchedText.isEmpty {
                print("DEBUG: Fetched Policy: \(fetchedText)") // Log success
                DispatchQueue.main.async {
                    self?.privacyPolicy = self?.formatLegalText(fetchedText) ?? fetchedText
                }
            } else {
                print("DEBUG: Policy snapshot is empty or nil")
            }
        }, withCancel: { [weak self] error in
            print("ERROR: Firebase Policy Fetch Failed: \(error.localizedDescription)")
        })
        
        // Fetch Terms: Text/Terms
        ref.child("Text/Terms").observe(.value, with: { [weak self] snapshot in
            // Safe helper to get string from any value (String or Int)
            var fetchedText = ""
            if let stringVal = snapshot.value as? String {
                fetchedText = stringVal
            } else if let numberVal = snapshot.value as? NSNumber {
                fetchedText = numberVal.stringValue
            }
            
            if !fetchedText.isEmpty {
                print("DEBUG: Fetched Terms: \(fetchedText)") // Log success
                DispatchQueue.main.async {
                    self?.termsAndConditions = self?.formatLegalText(fetchedText) ?? fetchedText
                    self?.isLoading = false
                }
            } else {
                print("DEBUG: Terms snapshot is empty or nil. Loading complete.")
                DispatchQueue.main.async {
                    self?.isLoading = false
                }
            }
        }, withCancel: { [weak self] error in
            print("ERROR: Firebase Terms Fetch Failed: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self?.isLoading = false
            }
        })
    }
    
    private func formatLegalText(_ raw: String) -> String {
        // 1. Handle literal newlines and escaped newlines
        // User requested replacing "\\n" with "\n", but for Markdown we often need "\n\n" for a break.
        // We'll use "\n\n" to be safe for paragraph separation.
        var text = raw.replacingOccurrences(of: "\\n", with: "\n\n")
        
        // Helper to apply regex replacement
        func applyRegex(_ pattern: String, template: String = "\n\n") {
            if let regex = try? NSRegularExpression(pattern: pattern) {
                let range = NSRange(location: 0, length: text.utf16.count)
                text = regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: template)
            }
        }
        
        // 2. Fix "20251." -> "2025\n\n1."
        // Lookbehind for a digit, Lookahead for number+dot
        applyRegex("(?<=\\d)(?=\\d+\\.)")
        
        // 3. Fix "Conditions1." -> "Conditions\n\n1."
        // Lookbehind for letter, Lookahead for number+dot
        applyRegex("(?<=[a-zA-Z])(?=\\d+\\.)")
        
        // 4. Fix "ConditionsLast updated" -> "Conditions\n\nLast updated"
        applyRegex("(?<=[a-zA-Z])(?=Last updated)")
        
        // 5. Ensure all numbered items (like "1. ", "2. ") have a double newline before them
        // Use capture group $1 to preserve the number
        applyRegex("(?<!\\n\\n)(\\d+\\.\\s)", template: "\n\n$1")
        
        return text
    }
}
