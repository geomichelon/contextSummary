import Combine
import Foundation

/// ViewModel for handling text summarization in the UI.
/// Manages input text, summary output, loading states, and errors.
class SummarizerViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var summary: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let repository: SummarizerRepository

    init(repository: SummarizerRepository) {
        self.repository = repository
    }

    /// Summarizes the input text using the injected repository.
    /// Updates loading and error states accordingly.
    func summarize() {
        guard !inputText.isEmpty else { return }

        Task {
            await MainActor.run {
                isLoading = true
                errorMessage = nil
            }

            do {
                let result = try await repository.summarizeText(inputText)
                await MainActor.run {
                    summary = result
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                }
            }

            await MainActor.run {
                isLoading = false
            }
        }
    }
}
