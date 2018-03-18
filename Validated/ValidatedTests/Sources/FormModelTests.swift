import XCTest
import Foundation
@testable import Validated

class FormModelTests: XCTestCase {
    func testInitialStateIsInvalid() throws {
        let model = FormModel()
        model.state.assert(startsWith: [.invalid]) { }
    }
}
