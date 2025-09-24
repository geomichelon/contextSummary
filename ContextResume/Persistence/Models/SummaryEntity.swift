//
//  SummaryEntity.swift
//  ContextResume
//
//  Created by Jim Alejandro Caicedo Osorio on 23/09/25.
//


import Foundation
import SwiftData

@Model
final class SummaryEntity {
    @Attribute(.unique) var id: UUID
    var text: String
    var createdAt: Date
    
    init(text: String, createdAt: Date = Date()) {
        self.id = UUID()
        self.text = text
        self.createdAt = createdAt
    }
}

extension SummaryEntity{
    public static func mock() -> SummaryEntity {
        SummaryEntity(text: "mock text", createdAt: Date())
    }
}
