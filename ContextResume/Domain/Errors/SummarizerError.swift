import Foundation

/// Errors that can occur during text summarization operations.
enum SummarizerError: Error {
    case noResponse
    case invalidStatus(Int)
    case malformedData
    case invalidAPIKey
    case networkError(String)
}

// MARK: - User Friendly Messages

extension SummarizerError {
    var userFriendlyMessage: String {
        switch self {
        case .noResponse:
            return "No response from server. Please check your internet connection."
        case .invalidStatus(let code):
            switch code {
            case 401:
                return "Invalid API key. Please check your OpenAI API key configuration."
            case 429:
                return "Too many requests. Please wait a moment and try again."
            case 500...599:
                return "OpenAI server error. Please try again later."
            default:
                return "Request failed with status code \(code). Please try again."
            }
        case .malformedData:
            return "Received invalid response from server. Please try again."
        case .invalidAPIKey:
            return "API key not configured. Please set up your OpenAI API key."
        case .networkError(let details):
            return "Network error: \(details). Please check your internet connection."
        }
    }
}
