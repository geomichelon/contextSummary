//
//  ContextResumeApp.swift
//  ContextResume
//  Created by George Michelon on 17/09/25.

import SwiftUI
import SwiftData

@main
struct ContextResumeApp: App {
    private let repo: SummarizerRepository = {
        let llmService = LLMServiceFactory.createService()
        return LLMServiceAdapter(llmService: llmService)
    }()

    var body: some Scene {
        WindowGroup {
            SummarizerView(repository: repo)
        }
        .modelContainer(for: SummaryEntity.self)
    }
}

