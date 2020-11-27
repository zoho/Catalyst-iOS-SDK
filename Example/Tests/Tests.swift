
//import XCTest
//@testable import Catalyst
//
//class Tests: XCTestCase {
//    
//    let app: CatalystApp = Catalyst.default
//    let app2: CatalystApp = Catalyst.configure(name: "Second", options: .settings(plistName: "App2"), environment: .production)
//    
//    override func setUp() {
//        super.setUp()
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//
//    }
//    
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        super.tearDown()
//    }
//    
//    
//    func testConfiguration()
//    {
//        XCTAssertEqual(app.appConfiguration.clientID, "10013818936.COER1GMIATBF50904FFQVDIZEMOAJH")
//        XCTAssertEqual(app.appConfiguration.clientSecretID, "a7b0eae40f4da40d6f6b2dec43898db56bba9a6bac")
//        XCTAssertEqual(app.appConfiguration.redirectURLScheme, "JobsAdmin://")
//        XCTAssertEqual(app.appConfiguration.projectID, "3374000000003001")
//        XCTAssertEqual(app.appConfiguration.portalID, "10013818936")
////        XCTAssertEqual(app.appConfiguration.apiBaseURL, <#T##expression2: Equatable##Equatable#>)
//    }
//    
//    func testSecondAppConfig()
//    {
//        XCTAssertEqual(app2.appConfiguration.clientID, "10013846068.UBTRLVCY1RTL55501OJK8BCSU370HH")
//        XCTAssertEqual(app2.appConfiguration.clientSecretID, "8ae669c83bd7e5f93b252eae6b0ae49ac2cfc562f1")
//        XCTAssertEqual(app2.appConfiguration.redirectURLScheme, "://")
//        XCTAssertEqual(app2.appConfiguration.projectID, "3374000000011126")
//        XCTAssertEqual(app2.appConfiguration.portalID, "10013846068")
//    }
//    
//    func testConfigOptions()
//    {
//        
//        
//    }
//    
//    func testFunctionsSuccess()
//    {
//        
//        let mockClient = MockParker(alwaysSuccess: true)
//        let function = Function(app: app, networkClient: mockClient)
//        
//        function.invoke(functionName: "asdasd", parameters: ["test":"hello"]) { result in
//            switch result
//            {
//            case .success(let fn):
//                let status = fn.output["statusCode"] as! Int
//                XCTAssertEqual(200, status)
//            case .error(let error):
//                debugPrint(error)
//            }
//        }
//    }
//    
//    func testFunctionsFailure()
//    {
//        let function = Function(app: app)
//        let mockClient = MockParker(alwaysSuccess: false)
//        
//        function.invoke(functionName: "asdasd", parameters: ["test":"hello"]) { result in
//            switch result
//            {
//            case .success(let fn):
//                let status = fn.output["staus"] as! String
//                XCTAssertEqual("failure", status)
//            case .error(let error):
//                debugPrint(error)
//            }
//        }
//    }
//    
//
//    
////    func testPerformanceExample() {
////        // This is an example of a performance test case.
////        self.measure() {
////            // Put the code you want to measure the time of here.
////        }
////    }
//    
//}
