import XCTest
import CSwift

final class CSwiftTests: XCTestCase {
    func testExample() {
        let result = c_add(2, 3)
        XCTAssertEqual(result, 5)
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
