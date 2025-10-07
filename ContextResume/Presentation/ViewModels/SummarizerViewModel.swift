import Combine
import Foundation
import SwiftData

/// ViewModel for handling text summarization in the UI.
/// Manages input text, summary output, loading states, and errors.
class SummarizerViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var summary: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // ✅ Nueva propiedad para manejar navegación
    @Published var shouldShowSummaries: Bool = false
    
    private let repository: SummarizerRepository
    private var context: ModelContext?   // ✅ Persistencia con SwiftData

    init(repository: SummarizerRepository, context: ModelContext? = nil) {
        self.repository = repository
        self.context = context
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
            } catch let error as SummarizerError {
                await MainActor.run {
                    errorMessage = error.userFriendlyMessage
                }
            } catch {
                await MainActor.run {
                    errorMessage = "Unexpected error: \(error.localizedDescription)"
                }
            }

            await MainActor.run {
                isLoading = false
            }
        }
    }

    /// ✅ Guarda el resumen actual en persistencia local
    func saveSummary() {
        guard let context = context else { return }
        guard !summary.isEmpty else { return }

        let newSummary = SummaryEntity(text: summary, createdAt: Date())
        context.insert(newSummary)

        do {
            try context.save()
        } catch {
            print("❌ Failed to save summary: \(error)")
        }
    }

    /// ✅ Cambia el flag para navegar a la lista de resúmenes
    func goToSummaries() {
        shouldShowSummaries = true
    }

    /// ✅ Limpia la entrada y el resumen actual
    func resetFields() {
        inputText = ""
        summary = ""
        errorMessage = nil
    }
}
