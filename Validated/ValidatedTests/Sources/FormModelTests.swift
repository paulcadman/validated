import XCTest
import Foundation
@testable import Validated

class FormModelTests: XCTestCase {
    func testInitialStateIsInvalid() throws {
        let model = FormModel()
        model.state.assert(startsWith: [.invalid]) { }
    }
    
    func testUpdateToNonEmptyStringIsValid() throws {
        let model = FormModel()
        model.state.assert(startsWith: [.invalid, .valid]) {
            model.updateName.onNext("h")
        }
    }
    
    func testUpdateToEmptyStringRemainsInvalid() throws {
        let model = FormModel()
        model.state.assert(startsWith: [.invalid]) {
            model.updateName.onNext("")
        }
    }
}
