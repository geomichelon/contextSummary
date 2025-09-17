import SwiftUI

/// SwiftUI view for text summarization.
/// Provides input field, summarize button, loading indicator, and displays results or errors.
struct SummarizerView: View {
    @StateObject private var viewModel: SummarizerViewModel

    init(repository: SummarizerRepository) {
        _viewModel = StateObject(wrappedValue: SummarizerViewModel(repository: repository))
    }

    var body: some View {
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

            if viewModel.isLoading {
                ProgressView("Summarizing...")
                    .progressViewStyle(.circular)
            }

            if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }

            if !viewModel.summary.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Summary:")
                        .font(.headline)

                    Text(viewModel.summary)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Text Summarizer")
    }
}

#Preview {
    SummarizerView(repository: MockSummarizerRepository())
}
