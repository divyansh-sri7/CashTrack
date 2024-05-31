import SwiftUI

public func playFeedbackHaptic(_ selected: Bool) {
    if selected == true {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}
