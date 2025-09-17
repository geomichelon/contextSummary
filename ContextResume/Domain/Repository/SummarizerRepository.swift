/// Protocol defining the contract for summarization services.
/// This protocol is framework-agnostic and can be implemented by remote APIs or mock services.
protocol SummarizerRepository {
    /// Summarizes the provided text asynchronously.
    /// - Parameter text: The text to be summarized.
    /// - Returns: A summarized version of the input text.
    /// - Throws: An error if the summarization fails.
    func summarizeText(_ text: String) async throws -> String
}
