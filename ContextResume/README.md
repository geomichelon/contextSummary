# ContextResume

A SwiftUI application for text summarization using OpenAI's API, built with clean architecture principles.

## Architecture

The project follows Clean Architecture principles, organized into the following layers:

### Domain
- **Repository**: Contains the `SummarizerRepository` protocol that defines the contract for text summarization services. This layer is framework-agnostic and contains business logic interfaces.

### Data
- **Remote**: `OpenAISummarizerRepository` implements the repository protocol using OpenAI's Chat Completions API via URLSession.
- **Mock**: `MockSummarizerRepository` provides a mock implementation for testing and previews, returning static responses without network calls.

### Presentation
- **ViewModels**: `SummarizerViewModel` manages UI state and business logic, handling loading states, errors, and coordinating with the repository layer.
- **Views**: `SummarizerView` provides the SwiftUI interface with TextEditor for input, summarize button, loading indicators, and result display.

### Config
- **EnvironmentConfig**: Manages environment variables, specifically the OpenAI API key loaded from `OPENAI_API_KEY`.

## Key Design Decisions

### Repository Pattern
- **Rationale**: Separates data access logic from business logic, allowing easy switching between different data sources (remote API, mock, local storage) without affecting the UI layer.
- **Benefits**: Improves testability, maintainability, and allows for dependency injection.

### Dependency Injection
- **Rationale**: ViewModels and Views receive their dependencies (repositories) through initialization, making the code more modular and testable.
- **Benefits**: Enables easy mocking in tests and supports different configurations (development, production, testing).

### Testability
- **Rationale**: Each layer has clear interfaces and dependencies are injected, allowing comprehensive unit testing.
- **Benefits**: High test coverage ensures reliability and supports refactoring with confidence.

### Async/Await
- **Rationale**: Modern Swift concurrency provides better error handling and avoids callback hell.
- **Benefits**: Cleaner, more readable asynchronous code that's easier to test.

## Running Tests

### In Xcode
1. Open `ContextResume.xcodeproj`
2. Ensure code coverage is enabled:
   - Edit Scheme → Test → Options
   - Check "Gather coverage for all targets"
3. Select the test target
4. Press `⌘U` or go to Product → Test
5. View coverage report:
   - After tests complete, go to Report Navigator (⌘9)
   - Select the latest test report
   - Click "Coverage" tab to view detailed coverage metrics

### Command Line
```bash
xcodebuild test -scheme ContextResume -destination 'platform=iOS Simulator,name=iPhone 15' -enableCodeCoverage YES
```

## Edge Cases Handling

### No Network Connection
- **OpenAI Repository**: Throws `URLError` when network is unavailable
- **UI**: Displays error message to user, loading state properly managed

### Empty Input
- **ViewModel**: Guards against empty input text, preventing unnecessary API calls
- **UI**: Button disabled when input is empty

### API Errors
- **Invalid API Key**: OpenAI returns 401 Unauthorized, caught and displayed as user-friendly error
- **Rate Limiting**: API returns 429, handled as error with retry suggestion
- **Malformed Response**: JSON decoding failures caught and displayed as "malformed data" error
- **UI**: All errors displayed in red text with descriptive messages

## Test Coverage

The project maintains at least **80% automated test coverage** through comprehensive unit tests covering:
- Repository implementations (mock and OpenAI)
- ViewModel state management and error handling
- Async operation testing with proper timing

## Setup

1. Clone the repository
2. Open `ContextResume.xcodeproj` in Xcode
3. Set your OpenAI API key in Xcode scheme environment variables:
   - Edit Scheme → Run → Environment Variables
   - Add `OPENAI_API_KEY` with your API key value
4. Run the app or tests

## Requirements

- iOS 18.5+
- Xcode 15+
- Swift 5.9+
