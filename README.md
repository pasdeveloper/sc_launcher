# SC Launcher

A Flutter utility application designed to automatically find and launch the latest active domain for the "Streaming Community" service.

## 📥 Download

You can download the latest version of the APK directly from the GitHub Releases page:

[**Download Latest APK**](https://github.com/pasdeveloper/sc_launcher/releases/latest)

## 🚀 How It Works

This application solves the problem of frequent domain changes by automating the retrieval process. Here is the step-by-step logic:

1.  **Source Monitoring**: The app connects to the official [Streaming Community Telegram Channel](https://t.me/s/Streaming_community_sito).
2.  **Data Parsing**: It parses the latest messages on the channel looking for specific updates.
3.  **Domain Extraction**: The app searches for the keyword **"Nuovo:"** in the messages, which signals a domain update announcement. It then intelligently extracts and sanitizes the new URL.
4.  **Auto-Launch**: Once a valid URL is found, the app attempts to **automatically open it** in your default web browser.
5.  **Fallback Interface**: If the automatic launch is blocked or fails, a button is provided to manually open the link. The interface also allows you to refresh/retry if the connection fails.

## Getting Started

To get started with this project, ensure you have Flutter installed on your machine.

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Dart SDK (included with Flutter)

### Installation

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/pasdeveloper/sc_launcher.git
    cd sc_launcher
    ```

2.  **Install dependencies:**

    ```bash
    flutter pub get
    ```

### Usage

**Running the app:**

To run the application in development mode:

```bash
flutter run
```

**Building the app:**

To build the APK for Android:

```bash
flutter build apk
```

To build for iOS (requires macOS):

```bash
flutter build ios
```

## Features

- **Automated Domain Discovery**: No need to manually search for the new site address.
- **Telegram Integration**: Scrapes public channel data securely using standard HTTP requests.
- **Auto-Redirect**: Opens the target site immediately upon discovery.
- **Error Handling**: Robust error management with retry capabilities for network issues.
- **Built with Flutter**: Cross-platform compatibility.

## Dependencies

- `url_launcher`: For opening external browser links.
- `http`: For fetching the Telegram channel content.
- `html`: For parsing the HTML structure of the Telegram public view.
