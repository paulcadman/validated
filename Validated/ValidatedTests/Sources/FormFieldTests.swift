import XCTest
import SwiftCheck
@testable import Validated

class NameFormFieldTests: XCTestCase {
    func testEmptyStringIsInvalid() {
        let name = FormModel.Validators.name
        XCTAssertEqual(name(""), FieldState.invalid(value: "", reason: .emptyName))
    }
    
    func testNonEmptyStringIsValid() {
        let name = FormModel.Validators.name
        property("All non-empty strings are valid") <- forAll { (s : String) in
            return (!s.isEmpty) ==> {
                return name(s) == FieldState.valid(value: s)
            }
        }
    }
}
