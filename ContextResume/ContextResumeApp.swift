//
//  ContextResumeApp.swift
//  ContextResume
//  Created by George Michelon on 17/09/25.

import SwiftUI

@main
struct ContextResumeApp: App {
    // LLM Service injection - automatically chooses the best available provider
    private let repo: SummarizerRepository = {
        let llmService = LLMServiceFactory.createService()
        return LLMServiceAdapter(llmService: llmService)
    }()

    var body: some Scene {
        WindowGroup {
            SummarizerView(repository: repo)
        }
    }
}
