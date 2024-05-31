import Foundation
import RealmSwift
import SwiftUI

final class AppViewModel: ObservableObject {
    
    @AppStorage("playFeedbackHaptic") var selectedFeedbackHaptic: Bool = true
    @AppStorage("hasRunBefore") var hasRunBefore: Bool = false
    
    init() {
        let config = Realm.Configuration(schemaVersion: 15)
        Realm.Configuration.defaultConfiguration = config
    }
}
