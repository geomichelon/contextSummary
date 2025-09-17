import XCTest
import SwiftUI
@testable import ContextResume

@MainActor
final class SummarizerViewTests: XCTestCase {
    
    func testSummarizerViewInitialization() {
        let repository = MockSummarizerRepository()
        let view = SummarizerView(repository: repository)
        
        // Test that view can be created without crashing
        XCTAssertNotNil(view)
    }
    
    func testSummarizerViewWithMockRepository() {
        let repository = MockSummarizerRepository()
        let view = SummarizerView(repository: repository)
        
        // Test view creation with mock repository
        XCTAssertNotNil(view)
    }
    
    func testSummarizerViewWithOpenAIRepository() {
        let repository = OpenAISummarizerRepository()
        let view = SummarizerView(repository: repository)
        
        // Test view creation with OpenAI repository
        XCTAssertNotNil(view)
    }
}
