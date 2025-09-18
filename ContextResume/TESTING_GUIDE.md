# 🧪 Complete Testing Guide - ContextResume

## 📋 Overview

This guide provides detailed instructions for creating, running, and maintaining tests in the ContextResume project, an iOS app built with SwiftUI using MVVM architecture with Clean Architecture.

## 🏗️ Test Structure

### File Organization
```
ContextResumeTests/
├── SummarizerViewModelTests.swift    # Presentation layer tests
├── SummarizerRepositoryTests.swift   # Data layer tests
└── SummarizerViewTests.swift         # Basic UI tests
```

### Test Architecture
- **Unit Tests**: ViewModels, Repositories, Services
- **Integration Tests**: Complete data flow
- **UI Tests**: SwiftUI components (basic)

## 🎯 Implemented Test Patterns

### 1. **ViewModel Tests** (`SummarizerViewModelTests.swift`)

```swift
@MainActor
final class SummarizerViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }

    // Success test
    func testSuccessfulSummarizationUpdatesSummary() async throws {
        let repository = MockSummarizerRepository()
        let viewModel = SummarizerViewModel(repository: repository)

        viewModel.inputText = "Test input text"
        viewModel.summarize()

        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(viewModel.summary, "Expected summary")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }

    // Error test with expectation
    func testErrorCaseUpdatesErrorMessage() async throws {
        let repository = ThrowingMockRepository()
        let viewModel = SummarizerViewModel(repository: repository)

        let expectation = XCTestExpectation(description: "Error handling completed")

        let cancellable = viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                if errorMessage != nil {
                    expectation.fulfill()
                }
            }

        viewModel.summarize()
        await fulfillment(of: [expectation], timeout: 2.0)

        XCTAssertNotNil(viewModel.errorMessage)
    }
}
```

### 2. **Repository Tests** (`SummarizerRepositoryTests.swift`)

```swift
final class SummarizerRepositoryTests: XCTestCase {

    func testMockSummarizerReturnsExpectedString() async throws {
        let repository = MockSummarizerRepository()
        let result = try await repository.summarizeText("Test input")

        XCTAssertEqual(result, "Expected mock response")
    }

    func testOpenAISummarizerThrowsWithInvalidAPIKey() async throws {
        let repository = OpenAISummarizerRepository()

        do {
            _ = try await repository.summarizeText("Test input")
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertTrue(error.localizedDescription.contains("API"))
        }
    }
}
```

### 3. **View Tests** (`SummarizerViewTests.swift`)

```swift
final class SummarizerViewTests: XCTestCase {

    func testSummarizerViewInitialization() {
        let repository = MockSummarizerRepository()
        let view = SummarizerView(repository: repository)

        XCTAssertNotNil(view)
    }
}
```

## 🔧 Mocks and Test Doubles

### Mock Repository
```swift
struct MockSummarizerRepository: SummarizerRepository {
    func summarizeText(_ text: String) async throws -> String {
        return "This is a mock summary of the provided text."
    }
}

// For error tests
private struct ThrowingMockRepository: SummarizerRepository {
    func summarizeText(_ text: String) async throws -> String {
        throw NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "test error"])
    }
}
```

## 🚀 Execution Commands

### 1. **Run All Tests**
```bash
xcodebuild test -scheme ContextResume -destination 'platform=iOS Simulator,name=iPhone 17'
```

### 2. **Run with Code Coverage**
```bash
xcodebuild test -scheme ContextResume -destination 'platform=iOS Simulator,name=iPhone 17' -enableCodeCoverage YES -resultBundlePath build/TestResults.xcresult
```

### 3. **View Coverage Report**
```bash
xcrun xccov view --report --json build/TestResults.xcresult
```

### 4. **Run Specific Tests**
```bash
xcodebuild test -scheme ContextResume -destination 'platform=iOS Simulator,name=iPhone 17' -only-testing:ContextResumeTests/SummarizerViewModelTests
```

## 📊 Coverage Analysis

### Interpreting Results
```json
{
  "coveredLines": 378,
  "executableLines": 431,
  "lineCoverage": 0.87703016241299303
}
```

- **coveredLines**: Lines executed by tests
- **executableLines**: Total executable lines
- **lineCoverage**: Coverage percentage (87.77%)

### Coverage Goals
- **Minimum**: 80%
- **Recommended**: 85%+
- **Excellent**: 90%+

## 🎯 Best Practices

### 1. **Test Naming**
```swift
func test[ComponentTested][Scenario][ExpectedResult]() {
    // Example: testSummarizerViewModelSuccessfulSummarizationUpdatesSummary
}
```

### 2. **AAA Structure (Arrange-Act-Assert)**
```swift
func testExample() async throws {
    // Arrange - Prepare data and mocks
    let repository = MockSummarizerRepository()
    let viewModel = SummarizerViewModel(repository: repository)

    // Act - Execute action
    viewModel.summarize()

    // Assert - Verify result
    XCTAssertEqual(viewModel.summary, "Expected result")
}
```

### 3. **Async Tests**
```swift
// Use expectation for async operations
func testAsyncOperation() async throws {
    let expectation = XCTestExpectation(description: "Async operation completed")

    let cancellable = viewModel.$property
        .dropFirst()
        .sink { value in
            expectation.fulfill()
        }

    // Trigger async operation
    viewModel.performAsyncOperation()

    await fulfillment(of: [expectation], timeout: 2.0)
    cancellable.cancel()
}
```

### 4. **State Management**
```swift
@MainActor
final class ViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }
}
```

## 🔍 Test Debugging

### 1. **Detailed Logs**
```swift
func testWithLogging() {
    print("🧪 Starting test: \(#function)")

    // Test implementation

    print("✅ Test completed successfully")
}
```

### 2. **Conditional Breakpoints**
- Use breakpoints on XCTAssert to investigate failures
- Add conditions to stop only on specific scenarios

### 3. **Test Plans**
- Configure different test configurations
- Separate fast tests from slow ones

## 📈 Continuous Monitoring

### 1. **CI/CD Integration**
```yaml
# Example for GitHub Actions
- name: Run Tests
  run: |
    xcodebuild test \
      -scheme ContextResume \
      -destination 'platform=iOS Simulator,name=iPhone 17' \
      -enableCodeCoverage YES \
      -resultBundlePath TestResults.xcresult
```

### 2. **Automatic Reports**
- Configure alerts for coverage drops
- Generate HTML reports for visualization

## 🎨 AI Prompt - Creating New Tests

```
Create unit tests for the ContextResume project following these patterns:

CONTEXT:
- iOS SwiftUI project with MVVM + Clean Architecture
- Uses async/await for async operations
- Repository pattern for data abstraction
- ViewModels with @Published properties

REQUIRED STRUCTURE:
1. Use @MainActor for ViewModels
2. Configure setUp/tearDown for cancellables
3. Implement mocks for dependencies
4. Use XCTestExpectation for async operations
5. Follow AAA pattern (Arrange-Act-Assert)

SCENARIOS TO TEST:
- Success cases
- Error cases
- Loading states
- Input validations
- Async flows

OUTPUT EXAMPLE:
```swift
@MainActor
final class [Component]Tests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = []
    }

    // Implement tests following established patterns
}
```

COMPONENT TO TEST: [Specify component]
FUNCTIONALITIES: [List specific functionalities]
```

## 🏆 Current Results

- **Total Coverage**: 87.77%
- **Tests Passed**: 7/7 (100%)
- **Status**: ✅ All tests passing
- **Goal**: ✅ Exceeded (80% → 87.77%)

---

*This guide was created based on the successful test implementation in the ContextResume project, achieving 87.77% code coverage.*
