import Foundation

/// Implementation of SummarizerRepository using OpenAI's Chat Completions API.
struct OpenAISummarizerRepository: SummarizerRepository {
    private let apiKey: String

    init() {
        self.apiKey = EnvironmentConfig.openAIKey
    }

    func summarizeText(_ text: String) async throws -> String {
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let prompt = "Please provide a concise summary of the following text:\n\n\(text)"
        let body = OpenAIRequest(model: "gpt-3.5-turbo", messages: [Message(role: "user", content: prompt)])
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw SummarizerError.noResponse
        }

        guard httpResponse.statusCode == 200 else {
            throw SummarizerError.invalidStatus(httpResponse.statusCode)
        }

        let openAIResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)

        guard let summary = openAIResponse.choices.first?.message.content else {
            throw SummarizerError.malformedData
        }

        return summary
    }
}

// MARK: - OpenAI API Models

private struct OpenAIRequest: Codable {
    let model: String
    let messages: [Message]
}

private struct Message: Codable {
    let role: String
    let content: String
}

private struct OpenAIResponse: Codable {
    let choices: [Choice]
}

private struct Choice: Codable {
    let message: Message
}

// MARK: - Errors

enum SummarizerError: Error {
    case noResponse
    case invalidStatus(Int)
    case malformedData
}
