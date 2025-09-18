/// Legacy protocol for backward compatibility.
/// New implementations should use LLMService protocol instead.
protocol SummarizerRepository {
    /// Summarizes the provided text asynchronously.
    /// - Parameter text: The text to be summarized.
    /// - Returns: A summarized version of the input text.
    /// - Throws: An error if the summarization fails.
    func summarizeText(_ text: String) async throws -> String
}

/// Adapter to bridge LLMService with legacy SummarizerRepository protocol
struct LLMServiceAdapter: SummarizerRepository {
    private let llmService: LLMService

    init(llmService: LLMService) {
        self.llmService = llmService
    }

    func summarizeText(_ text: String) async throws -> String {
        return try await llmService.summarizeText(text)
    }
}
