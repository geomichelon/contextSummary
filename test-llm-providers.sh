#!/bin/bash

# ContextResume - LLM Provider Testing Script
# This script helps test different LLM providers

echo "🧪 ContextResume - LLM Provider Testing"
echo "======================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to test a provider
test_provider() {
    local provider=$1
    local env_vars=$2
    local description=$3

    echo -e "\n${BLUE}Testing $provider${NC}"
    echo "$description"
    echo "Environment: $env_vars"

    # Set environment and run tests
    eval "export $env_vars"
    if xcodebuild test -scheme ContextResume -destination 'platform=iOS Simulator,name=iPhone 17' -quiet; then
        echo -e "${GREEN}✅ $provider tests passed${NC}"
    else
        echo -e "${RED}❌ $provider tests failed${NC}"
    fi
}

echo "Testing different LLM providers..."

# Test Mock (should always work)
test_provider "Mock" "LLM_PROVIDER=mock" "Default mock implementation for development"

# Test OpenAI (only if key is available)
if [ -n "$OPENAI_API_KEY" ]; then
    test_provider "OpenAI" "LLM_PROVIDER=openai OPENAI_API_KEY=$OPENAI_API_KEY" "OpenAI GPT models"
else
    echo -e "\n${YELLOW}⚠️  OpenAI tests skipped - no API key found${NC}"
    echo "Set OPENAI_API_KEY environment variable to test OpenAI"
fi

# Test Anthropic (only if key is available)
if [ -n "$ANTHROPIC_API_KEY" ]; then
    test_provider "Anthropic" "LLM_PROVIDER=anthropic ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY" "Anthropic Claude models"
else
    echo -e "\n${YELLOW}⚠️  Anthropic tests skipped - no API key found${NC}"
    echo "Set ANTHROPIC_API_KEY environment variable to test Anthropic"
fi

# Test Google (only if key is available)
if [ -n "$GOOGLE_API_KEY" ]; then
    test_provider "Google" "LLM_PROVIDER=google GOOGLE_API_KEY=$GOOGLE_API_KEY" "Google Gemini models"
else
    echo -e "\n${YELLOW}⚠️  Google tests skipped - no API key found${NC}"
    echo "Set GOOGLE_API_KEY environment variable to test Google"
fi

echo -e "\n${GREEN}🎉 LLM Provider testing completed!${NC}"
echo
echo "To run the app with a specific provider:"
echo "export LLM_PROVIDER=openai  # or anthropic, google, mock"
echo "export OPENAI_API_KEY=your-key-here"
echo "open ContextResume.xcodeproj"
