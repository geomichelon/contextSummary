import Foundation

/// OpenAI implementation of LLMService using Chat Completions API.
struct OpenAILLMService: LLMService {
    private let apiKey: String

    init() {
        self.apiKey = EnvironmentConfig.openAIKey
    }

    func summarizeText(_ text: String) async throws -> String {
        print("🔄 Starting OpenAI API call...")

        guard !apiKey.isEmpty else {
            print("❌ API Key is empty")
            throw SummarizerError.invalidAPIKey
        }

        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30

        let prompt = "Please provide a concise summary of the following text:\n\n\(text)"
        let body = OpenAIRequest(model: "gpt-3.5-turbo", messages: [Message(role: "user", content: prompt)])
        request.httpBody = try JSONEncoder().encode(body)

        print("📡 Making API request to OpenAI...")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ No HTTP response received")
                throw SummarizerError.noResponse
            }

            print("📊 HTTP Status Code: \(httpResponse.statusCode)")

            guard httpResponse.statusCode == 200 else {
                if let errorData = String(data: data, encoding: .utf8) {
                    print("❌ API Error Response: \(errorData)")
                }
                throw SummarizerError.invalidStatus(httpResponse.statusCode)
            }

            let openAIResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
            print("✅ Successfully decoded OpenAI response")

            guard let summary = openAIResponse.choices.first?.message.content else {
                print("❌ No summary content in response")
                throw SummarizerError.malformedData
            }

            print("✅ Summary generated successfully")
            return summary

        } catch let urlError as URLError {
            print("❌ Network Error: \(urlError.localizedDescription)")
            throw SummarizerError.networkError(urlError.localizedDescription)
        } catch {
            print("❌ Unexpected Error: \(error.localizedDescription)")
            throw error
        }
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
