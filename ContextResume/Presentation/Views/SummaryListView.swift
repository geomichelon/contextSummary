//
//  SummaryListView.swift
//  ContextResume
//
//  Created by Jim Alejandro Caicedo Osorio on 23/09/25.
//

import SwiftUI
import SwiftData

struct SummaryListView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel: SummaryListViewModel
    
    init(context: ModelContext) {
        _viewModel = StateObject(wrappedValue: SummaryListViewModel(context: context))
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.summaries.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "tray")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text("No summaries saved yet.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                } else {
                    List {
                        ForEach(viewModel.summaries, id: \.id) { summary in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(summary.text)
                                    .font(.body)
                                    .lineLimit(3)
                                
                                Text(summary.createdAt, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.map { viewModel.summaries[$0] }
                                .forEach(viewModel.deleteSummary)
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("My Summaries")
        }
    }
}

#Preview {
    let mockSummaries = [
        SummaryEntity(text: "Resumen de prueba 1: Este es un resumen corto generado para preview.", createdAt: Date()),
        SummaryEntity(text: "Resumen de prueba 2: Otro ejemplo más largo para mostrar cómo se ven las notas guardadas en la lista del preview.", createdAt: Date().addingTimeInterval(-3600)),
        SummaryEntity(text: "Resumen de prueba 3: Texto simulado.", createdAt: Date().addingTimeInterval(-86400))
    ]
    
    return SummaryListView_PreviewWrapper(mockSummaries: mockSummaries)
}

struct SummaryListView_PreviewWrapper: View {
    @StateObject private var viewModel: MockSummaryListViewModel
    
    init(mockSummaries: [SummaryEntity]) {
        _viewModel = StateObject(wrappedValue: MockSummaryListViewModel(previewData: mockSummaries))
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.summaries, id: \.id) { summary in
                    VStack(alignment: .leading) {
                        Text(summary.text).font(.body)
                        Text(summary.createdAt, style: .date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Preview Summaries")
        }
    }
}
