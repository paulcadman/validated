import XCTest
@testable import Validated

class FormModelTests: XCTestCase {
    func testInitialStateIsValid() {
        FormModel().state.verify(startsWith: [.valid])
    }
}
