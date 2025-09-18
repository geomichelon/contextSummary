import XCTest
import Combine
@testable import ContextResume

@MainActor
final class SummarizerViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }

    func testSuccessfulSummarizationUpdatesSummary() async throws {
        let repository = MockSummarizerRepository()
        let viewModel = SummarizerViewModel(repository: repository)

        viewModel.inputText = "Test input text"

        viewModel.summarize()

        // Wait for async operation to complete
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds

        XCTAssertEqual(viewModel.summary, "This is a mock summary of the provided text. It provides a consistent response for testing and preview purposes.")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testErrorCaseUpdatesErrorMessage() async throws {
        let repository = ThrowingMockRepository()
        let viewModel = SummarizerViewModel(repository: repository)

        viewModel.inputText = "Test input text"

        // Create expectation for async operation
        let expectation = XCTestExpectation(description: "Error handling completed")

        // Monitor changes to errorMessage
        let cancellable = viewModel.$errorMessage
            .dropFirst() // Skip initial nil value
            .sink { errorMessage in
                if errorMessage != nil {
                    expectation.fulfill()
                }
            }

        viewModel.summarize()

        // Wait for the expectation to be fulfilled
        await fulfillment(of: [expectation], timeout: 2.0)

        cancellable.cancel()

        XCTAssertEqual(viewModel.summary, "")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
        // Now the error message is converted to user-friendly format
        XCTAssertEqual(viewModel.errorMessage, "Unexpected error: test error")
    }

    func testIsLoadingTogglesCorrectly() async throws {
        let repository = MockSummarizerRepository()
        let viewModel = SummarizerViewModel(repository: repository)

        viewModel.inputText = "Test input text"

        // Initial state should be false
        XCTAssertFalse(viewModel.isLoading)

        // Create expectation for loading completion
        let expectation = XCTestExpectation(description: "Loading completed")
        
        let cancellable = viewModel.$isLoading
            .dropFirst() // Skip initial false value
            .sink { isLoading in
                if !isLoading {
                    expectation.fulfill()
                }
            }

        // Start summarization
        viewModel.summarize()

        // Wait for completion
        await fulfillment(of: [expectation], timeout: 2.0)
        
        cancellable.cancel()

        // Should be done loading
        XCTAssertFalse(viewModel.isLoading)
    }

    func testSummarizeWithEmptyInputDoesNothing() async throws {
        let repository = MockSummarizerRepository()
        let viewModel = SummarizerViewModel(repository: repository)

        viewModel.inputText = ""
        viewModel.summary = "Previous summary"
        viewModel.errorMessage = "Previous error"

        // Create expectation that should NOT be fulfilled
        let unexpectedChangeExpectation = XCTestExpectation(description: "Unexpected change")
        unexpectedChangeExpectation.isInverted = true
        
        let cancellable = viewModel.$summary
            .dropFirst() // Skip initial value
            .sink { _ in
                unexpectedChangeExpectation.fulfill()
            }

        viewModel.summarize()

        // Wait briefly to ensure no changes occur
        await fulfillment(of: [unexpectedChangeExpectation], timeout: 0.5)
        
        cancellable.cancel()

        // Should not change anything since input is empty
        XCTAssertEqual(viewModel.summary, "Previous summary")
        XCTAssertEqual(viewModel.errorMessage, "Previous error")
        XCTAssertFalse(viewModel.isLoading)
    }
}

// MARK: - Test Helpers

private struct ThrowingMockRepository: SummarizerRepository {
    func summarizeText(_ text: String) async throws -> String {
        throw NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "test error"])
    }
}
