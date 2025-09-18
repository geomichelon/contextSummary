/// Configuration struct for reading environment variables.
/// Used to load API keys and other environment-specific settings.

import Foundation
struct EnvironmentConfig {
    /// OpenAI API key loaded from environment variables.
    /// Defaults to an empty string if not found.

    static var openAIKey: String {
        let key = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] ?? ""
        print("🔑 API Key configured:", !key.isEmpty ? "YES" : "NO")
        return key
    }
}
