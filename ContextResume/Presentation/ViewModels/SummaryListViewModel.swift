//
//  SummaryListViewModel.swift
//  ContextResume
//
//  Created by Jim Alejandro Caicedo Osorio on 23/09/25.
//


import Foundation
import SwiftData
import Combine

@MainActor
class SummaryListViewModel: ObservableObject {
    @Published var summaries: [SummaryEntity] = []
    
    private let dataService: SummaryDataService
    
    init(context: ModelContext) {
        self.dataService = SummaryDataService(context: context)
        loadSummaries()
    }
    
    func loadSummaries() {
        summaries = dataService.fetchSummaries()
    }
    
    func saveSummary(text: String) {
        dataService.saveSummary(text)
        loadSummaries()
    }
    
    func deleteSummary(_ summary: SummaryEntity) {
        dataService.deleteSummary(summary)
        loadSummaries()
    }
}
