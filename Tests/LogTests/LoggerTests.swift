import XCTest
@testable import Log

@available(macOS 10.12, *)
final class LoggerTests: XCTestCase {
    let fileManager = FileManager()
    
    func testExample() {
        let url = fileManager.temporaryDirectory
        let fileURL = url.appendingPathComponent("test.log")
        fileManager.createFile(atPath: fileURL.path, contents: Data(), attributes: nil)
        
        let logger = Logger()
        let output = URLOutput(url: fileURL)
        logger.addOutput(output)
        logger.log("Test")
        
        do {
            let string = try String(contentsOf: fileURL)
            XCTAssertEqual(string, "Test\n")
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
