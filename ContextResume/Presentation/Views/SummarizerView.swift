import SwiftUI
import SwiftData

/// SwiftUI view for text summarization.
/// Provides input field, summarize button, loading indicator, and displays results or errors.
struct SummarizerView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel: SummarizerViewModel

    // 🔹 Control de navegación
    @State private var showSummaryList: Bool = false

    init(repository: SummarizerRepository) {
        _viewModel = StateObject(wrappedValue: SummarizerViewModel(repository: repository))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Enter text to summarize:")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                TextEditor(text: $viewModel.inputText)
                    .frame(height: 150)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                    .padding(.horizontal, 4)

                // 🔹 Botón Summarize
                Button(action: {
                    viewModel.summarize()
                }) {
                    Text("Summarize")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.inputText.isEmpty || viewModel.isLoading ? Color.gray : Color.blue)
                        .cornerRadius(8)
                }
                .disabled(viewModel.inputText.isEmpty || viewModel.isLoading)

                // 🔹 Estado de carga
                if viewModel.isLoading {
                    ProgressView("Summarizing...")
                        .progressViewStyle(.circular)
                }

                // 🔹 Errores
                if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }

                // 🔹 Resultado
                if !viewModel.summary.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Summary:")
                            .font(.headline)

                        Text(viewModel.summary)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        // ✅ Guardar en persistencia
                        Button(action: {
                            let newSummary = SummaryEntity(
                                text: viewModel.summary,
                                createdAt: Date()
                            )
                            context.insert(newSummary)
                            do {
                                try context.save()
                            } catch {
                                print("❌ Error saving summary: \(error)")
                            }
                        }) {
                            Label("Save to My Summaries", systemImage: "tray.and.arrow.down.fill")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(8)
                        }

                        // ✅ Navegar a SummaryListView
                        Button(action: {
                            showSummaryList = true
                        }) {
                            Label("View My Summaries", systemImage: "list.bullet")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.purple)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Text Summarizer")
            // 🔹 Aquí conectamos con tu SummaryListView real
            .navigationDestination(isPresented: $showSummaryList) {
                SummaryListView(context: context)
            }
        }
    }
}

#Preview {
    SummarizerView(repository: MockSummarizerRepository())
        .modelContainer(for: SummaryEntity.self, inMemory: true)
}
