import XCTest
@testable import AnyCodable

class AnyCodableTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testJSONDecoding() {
    let json = """
        {
            "boolean": true,
            "integer": 1,
            "double": 3.14159265358979323846,
            "string": "string",
            "array": [1, 2, 3],
            "nested": {
                "a": "alpha",
                "b": "bravo",
                "c": "charlie"
            }
        }
        """.data(using: .utf8)!
    
    let decoder = JSONDecoder()
    let dictionary = try! decoder.decode([String: AnyCodable].self, from: json)
    
    XCTAssertEqual(dictionary["boolean"]?.value as! Bool, true)
    XCTAssertEqual(dictionary["integer"]?.value as! Int, 1)
    XCTAssertEqual(dictionary["double"]?.value as! Double, 3.14159265358979323846, accuracy: 0.001)
    XCTAssertEqual(dictionary["string"]?.value as! String, "string")
    XCTAssertEqual(dictionary["array"]?.value as! [Int], [1, 2, 3])
    XCTAssertEqual(dictionary["nested"]?.value as! [String: String], ["a": "alpha", "b": "bravo", "c": "charlie"])
  }
  
  func testJSONEncoding() {
    let dictionary: [String: AnyCodable] = [
      "boolean": true,
      "integer": 1,
      "double": 3.14159265358979323846,
      "string": "string",
      "array": [1, 2, 3],
      "nested": [
        "a": "alpha",
        "b": "bravo",
        "c": "charlie"
      ]
    ]
    
    let encoder = JSONEncoder()
    
    let json = try! encoder.encode(dictionary)
    let encodedJSONObject = try! JSONSerialization.jsonObject(with: json, options: []) as! NSDictionary
    
    let expected = """
        {
            "boolean": true,
            "integer": 1,
            "double": 3.14159265358979323846,
            "string": "string",
            "array": [1, 2, 3],
            "nested": {
                "a": "alpha",
                "b": "bravo",
                "c": "charlie"
            }
        }
        """.data(using: .utf8)!
    let expectedJSONObject = try! JSONSerialization.jsonObject(with: expected, options: []) as! NSDictionary
    
    XCTAssertEqual(encodedJSONObject, expectedJSONObject)
  }
  
  static var allTests = [
    ("testJSONDecoding", testJSONDecoding),
    ("testJSONEncoding", testJSONEncoding),
    ]
  
}
