import XCTest
import Foundation
@testable import Validated

class FormModelTests: XCTestCase {
    func testInitialStateIsInvalid() throws {
        let model = FormModel()
        model.state.assert(startsWith: [.invalid(reason: .emptyName)]) { }
    }
    
    func testUpdateToNonEmptyStringIsValid() throws {
        let model = FormModel()
        model.state.assert(startsWith: [.invalid(reason: .emptyName), .valid]) {
            model.updateName.onNext("h")
        }
    }
    
    func testUpdateNonEmptyToEmptyIsInvalid() throws {
        let model = FormModel()
        model.state.assert(startsWith: [
            .invalid(reason: .emptyName),
            .valid,
            .invalid(reason: .emptyName)]) {
            model.updateName.onNext("h")
            model.updateName.onNext("")
        }
    }
    
    func testUpdateToEmptyStringRemainsInvalid() throws {
        let model = FormModel()
        model.state.assert(startsWith: [.invalid(reason: .emptyName)]) {
            model.updateName.onNext("")
        }
    }
}
