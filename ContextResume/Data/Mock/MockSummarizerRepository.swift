/// Mock implementation of SummarizerRepository for testing and previews.
/// Returns a static summary string without making any network calls.
struct MockSummarizerRepository: SummarizerRepository {
    func summarizeText(_ text: String) async throws -> String {
        return "This is a mock summary of the provided text. It provides a consistent response for testing and preview purposes."
    }
}
