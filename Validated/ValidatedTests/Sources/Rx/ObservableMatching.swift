import RxSwift
import RxTest
import RxBlocking
import XCTest

enum TestResult {
    case pass
    case fail(reason: String)
}

extension ObservableType {
    func expectSuccess(expectation: ([E]) -> TestResult) {
        let result = self.toBlocking(timeout: 1.0).materialize()
        switch result {
        case .completed(let elements):
            switch expectation(elements) {
            case .fail(let reason):
                XCTFail(reason)
            case .pass:
                break
            }
        case .failed(_, let error):
            XCTFail("Expected result to complete without error, but received \(error).")
        }
    }
}

extension ObservableType where E: Equatable {
    func verify(startsWith elements: [E]) {
        self.expectSuccess { actual in
            if actual.starts(with: elements, by: { $0 == $1 }) {
                return .pass
            } else {
                return .fail(reason: "Observable did not start with specified elements")
            }
        }
    }
}
