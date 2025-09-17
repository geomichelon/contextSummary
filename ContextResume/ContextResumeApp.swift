//
//  ContextResumeApp.swift
//  ContextResume
//
//  Created by George Michelon on 17/09/25.
//

import SwiftUI

@main
struct ContextResumeApp: App {
    // Repository injection point (generic). Default uses mock for previews/offline.
    // TODO: swap with live service when ready:
    // private let repo: SummarizerRepository = OpenAISummarizerRepository()
    private let repo: SummarizerRepository = MockSummarizerRepository()

    var body: some Scene {
        WindowGroup {
            SummarizerView(repository: repo)
        }
    }
}
