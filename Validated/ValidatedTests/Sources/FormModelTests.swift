import XCTest
import Foundation
@testable import Validated

class FormModelTests: XCTestCase {
    func testInitialStateIsInvalid() throws {
        let model = FormModel()
        model.state.assert(startsWith: [
            .invalid(
                name: "",
                reason: .emptyName
            )
        ]) { }
    }
    
    func testUpdateToNonEmptyStringIsValid() throws {
        let model = FormModel()
        model.state.assert(startsWith: [
            .invalid(
                name: "",
                reason: .emptyName
            ),
            .valid(
                name: "h"
            )
        ]) {
            model.updateName.onNext("h")
        }
    }
    
    func testUpdateNonEmptyToEmptyIsInvalid() throws {
        let model = FormModel()
        model.state.assert(startsWith: [
            .invalid(
                name: "",
                reason: .emptyName)
            ,
            .valid(
                name: "h"
            ),
            .invalid(
                name: "",
                reason: .emptyName
            )
        ]) {
            model.updateName.onNext("h")
            model.updateName.onNext("")
        }
    }
    
    func testUpdateToEmptyStringRemainsInvalid() throws {
        let model = FormModel()
        model.state.assert(startsWith: [
            .invalid(
                name: "",
                reason: .emptyName
            )
        ]) {
            model.updateName.onNext("")
        }
    }
}
