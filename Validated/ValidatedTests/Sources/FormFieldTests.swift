import XCTest
@testable import Validated

class NameFormFieldTests: XCTestCase {
    func testEmptyStringIsInvalid() {
        let name = FormModel.Validators.name
        XCTAssertEqual(name(""), FieldState.invalid(value: "", reason: .emptyName))
    }
}
