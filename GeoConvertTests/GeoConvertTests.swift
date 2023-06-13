import XCTest
@testable import GeoConvert

final class GeoConvertTests: XCTestCase {
    
    var coordinates: Coordinates! // Create object which we will test

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        coordinates = Coordinates() //Initialize out object
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        // Delete our object from memory
        coordinates = nil
        try super.tearDownWithError()
    }

    func testSK42_WGS84Conversion() {
        //Given:
            coordinates.SK42 = [42.0, 23.0, 100.0] // Set the SK42 coordinates
            
            coordinates.SK42_WGS84() // Perform the conversion
        
        //When:
        let expectedWGS84 = [41.999682830664185, 22.998317665891964, 0.0] // Set the expected WGS84 coordinates
            
        //Then:
            XCTAssertEqual(coordinates.WGS84, expectedWGS84, "SK42 to WGS84 conversion is incorrect")
        }

    func testWGS84_SK42Conversion() {
        //Given:
            coordinates.WGS84 = [42.123, 23.456, 0.0] // Set the WGS84 coordinates
            
            coordinates.WGS84_SK42() // Perform the conversion
            
            //When:
            let expectedSK42 = [42.1233089407134, 23.457682363676355, 0.0] // Set the expected SK42 coordinates
            
        //Then:
            XCTAssertEqual(coordinates.SK42, expectedSK42, "WGS84 to SK42 conversion is incorrect")
        }

}
