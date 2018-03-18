import XCTest
import Foundation
@testable import Validated

class FormModelTests: XCTestCase {
    func testInitialStateIsInvalid() throws {
        let model = FormModel()
        model.state.assert(startsWith: [
            .invalid(
                name: "",
                age: .none,
                reasons: [.emptyName, .emptyAge]
            )
        ]) { }
    }
    
    func testUpdateToNonEmptyStringIsInValid() throws {
        let model = FormModel()
        model.state.assert(startsWith: [
            .invalid(
                name: "",
                age: .none,
                reasons: [.emptyName, .emptyAge]
            ),
            .invalid(
                name: "h",
                age: .none,
                reasons: [.emptyAge]
            )
        ]) {
            model.updateName.onNext("h")
        }
    }
    
    func testUpdateNonEmptyNameAndAge30IsValid() throws {
        let model = FormModel()
        model.state.assert(startsWith: [
            .invalid(
                name: "",
                age: .none,
                reasons: [.emptyName, .emptyAge]
            ),
            .invalid(
                name: "h",
                age: .none,
                reasons: [.emptyAge]
            ),
            .valid(
                name: "h",
                age: 30
            )
        ]) {
            model.updateName.onNext("h")
            model.updateAge.onNext(30)
        }
    }
    
    func testUpdateNonEmptyNameAndAge10IsInValid() throws {
        let model = FormModel()
        model.state.assert(startsWith: [
            .invalid(
                name: "",
                age: .none,
                reasons: [.emptyName, .emptyAge]
            ),
            .invalid(
                name: "h",
                age: .none,
                reasons: [.emptyAge]
            ),
            .invalid(
                name: "h",
                age: .none,
                reasons: [.tooYoung]
            )
        ]) {
            model.updateName.onNext("h")
            model.updateAge.onNext(10)
        }
    }
    
    func testUpdateNonEmptyToEmptyIsInvalid() throws {
        let model = FormModel()
        model.state.assert(startsWith: [
            .invalid(
                name: "",
                age: .none,
                reasons: [.emptyName, .emptyAge])
            ,
            .invalid(
                name: "h",
                age: .none,
                reasons: [.emptyAge]
            ),
            .invalid(
                name: "",
                age: .none,
                reasons: [.emptyName, .emptyAge]
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
                age: .none,
                reasons: [.emptyName, .emptyAge]
            )
        ]) {
            model.updateName.onNext("")
        }
    }
}
