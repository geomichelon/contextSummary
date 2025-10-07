//
//  MockSummaryListViewModel.swift
//  ContextResume
//
//  Created by Jim Alejandro Caicedo Osorio on 23/09/25.
//


import Foundation
import SwiftData

@MainActor
final class MockSummaryListViewModel: SummaryListViewModel {
    init(previewData: [SummaryEntity]) {
        super.init(context: ModelContext(try! ModelContainer(for: SummaryEntity.self)))
        self.summaries = previewData
    }
}
