//
//  SummaryDataService.swift
//  ContextResume
//
//  Created by Jim Alejandro Caicedo Osorio on 23/09/25.
//


import Foundation
import SwiftData

@MainActor
final class SummaryDataService {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func saveSummary(_ text: String) {
        let newSummary = SummaryEntity(text: text)
        context.insert(newSummary)
        try? context.save()
    }
    
    func fetchSummaries() -> [SummaryEntity] {
        let descriptor = FetchDescriptor<SummaryEntity>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        return (try? context.fetch(descriptor)) ?? []
    }
    
    func deleteSummary(_ summary: SummaryEntity) {
        context.delete(summary)
        try? context.save()
    }
}
