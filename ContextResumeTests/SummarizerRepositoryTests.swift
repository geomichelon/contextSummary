import XCTest
@testable import ContextResume

final class SummarizerRepositoryTests: XCTestCase {

    func testMockSummarizerReturnsExpectedString() async throws {
        let repository = await MockSummarizerRepository()
        let result = try await repository.summarizeText("Some test text to summarize")
        let expected = "This is a mock summary of the provided text. It provides a consistent response for testing and preview purposes."
        XCTAssertEqual(result, expected)
    }

    func testOpenAISummarizerThrowsWithInvalidAPIKey() async throws {
        // Create repository with invalid API key scenario
        let repository = await OpenAISummarizerRepository()

        do {
            // Test with text that would normally work but should fail due to API key issues
            _ = try await repository.summarizeText("Test text")
            XCTFail("Expected to throw an error with invalid/missing API key")
        } catch {
            // Expected to throw due to invalid/empty API key or network issues
            XCTAssertNotNil(error)
            // Could be URLError, API error, or other network-related error
        }
    }

    func testOpenAISummarizerThrowsWithEmptyInput() async throws {
        let repository = await OpenAISummarizerRepository()

        do {
            _ = try await repository.summarizeText("")
            XCTFail("Expected to throw an error with empty input")
        } catch {
            // The method should handle empty input gracefully or throw
            XCTAssertNotNil(error)
        }
    }
}
