import Foundation

/// Mock implementation of LLMService for testing and development.
struct MockLLMService: LLMService {
    func summarizeText(_ text: String) async throws -> String {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds

        // Return a mock summary based on input length
        if text.isEmpty {
            return "No text provided to summarize."
        } else if text.count < 50 {
            return "This is a short text that has been summarized using mock AI."
        } else {
            return "This comprehensive text has been analyzed and condensed into a clear, concise summary using advanced mock AI processing. The key points and main ideas have been preserved while reducing the overall length for better readability."
        }
    }
}
