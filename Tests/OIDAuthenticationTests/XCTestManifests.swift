import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
  return [
    testCase(OIDAuthorizationServiceTests.allTests),
  ]
}
#endif
