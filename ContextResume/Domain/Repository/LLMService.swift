import Foundation

/// Protocol for LLM (Large Language Model) services.
/// Allows easy switching between different AI providers.
protocol LLMService {
    /// Generates a summary for the given text using the LLM.
    /// - Parameter text: The text to summarize
    /// - Returns: A summarized version of the text
    func summarizeText(_ text: String) async throws -> String
}

/// Configuration for LLM providers
enum LLMProvider: String {
    case openAI = "openai"
    case anthropic = "anthropic"
    case google = "google"
    case mock = "mock"

    /// Creates the appropriate LLM service based on the provider
    /// - Returns: Configured LLM service instance
    func createService() -> LLMService {
        switch self {
        case .openAI:
            return OpenAILLMService()
        case .anthropic:
            return AnthropicLLMService()
        case .google:
            return GoogleLLMService()
        case .mock:
            return MockLLMService()
        }
    }

    /// Determines the provider from environment configuration
    static var current: LLMProvider {
        let providerString = ProcessInfo.processInfo.environment["LLM_PROVIDER"]?.lowercased() ?? "mock"

        // If OpenAI key exists, default to OpenAI
        if ProcessInfo.processInfo.environment["OPENAI_API_KEY"]?.isEmpty == false {
            return .openAI
        }

        return LLMProvider(rawValue: providerString) ?? .mock
    }
}

/// Factory for creating LLM services
class LLMServiceFactory {
    static func createService() -> LLMService {
        return LLMProvider.current.createService()
    }

    static func createService(for provider: LLMProvider) -> LLMService {
        return provider.createService()
    }
}
