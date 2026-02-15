# CopilotDemo

A sample iOS application demonstrating CI with GitHub Actions and Xcode.

## Requirements
- Xcode 16 or later
- iOS 17 SDK or later
- Swift 5.10+

## Getting Started
1. Open `CopilotDemo.xcodeproj` in Xcode.
2. Select the `CopilotDemo` scheme.
3. Choose an iOS Simulator device (e.g., iPhone 15) and run.

## Building from the command line
You can build the app for the iOS Simulator using `xcodebuild`:

## Features:
- SwiftUI + MVVM
- Async/Await API
- GitHub Copilot assisted development
- GitHub Actions CI

```bash
xcodebuild \
  -project CopilotDemo.xcodeproj \
  -scheme CopilotDemo \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest' \
  clean build
  

