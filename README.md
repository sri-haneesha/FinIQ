# FinIQ

### Developed by:
- **Madhu Sudhan Reddy Konda**
- **Sri Haneesha Davuluri**

---
######
YouTube Demo
For a video walkthrough of FinIQ, check out our https://youtu.be/mUGl3vk6Yeo
######


## Project Description

**FinIQ** is a user-friendly financial management app built using **Flutter**. The application allows users to manage their finances in one place by tracking expenses, managing income, monitoring investments, and setting savings goals. With an intuitive design, FinIQ simplifies financial planning and helps users maintain control over their financial health. This project is designed to be secure, visually engaging, and easy to navigate, catering to users of all financial backgrounds.

---

## Technologies Used

- **Flutter**: Cross-platform framework for developing mobile applications on Android and iOS.
- **Dart**: Programming language used for Flutter applications.
- **SQLite**: Local database for securely storing and managing user data.
- **Charting Libraries**: Used for creating visually appealing graphs and charts to display financial data.

---

## Dependencies

Here are the key dependencies used in this project:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.3          # State management
  sqflite: ^2.0.2           # Local database for storing financial data
  path_provider: ^2.0.11    # Access device file storage
  charts_flutter: ^0.12.0   # For generating charts and graphs

# Getting Started

Follow these instructions to download and set up **FinIQ** on your local machine.

---

## Prerequisites

Make sure you have the following tools installed before setting up the project:

- **Flutter SDK**: Make sure Flutter is installed on your machine. If not, follow [this guide](https://docs.flutter.dev/get-started/install) to install Flutter.
- **Android Studio** or **Visual Studio Code**: Recommended for running and debugging Flutter projects.
- **Device or Emulator**: A physical device or emulator (iOS/Android) to test the app.

---

## Installation

1. **Clone the Repository**
   git clone https://github.com/yourusername/finiq.git
   cd finiq

2. **Install Dependencies**
   flutter pub get


3. **Set Up Database**
   SQLite is used for local storage. The app will create the database automatically on first launch.

4. **Run the Application**
   flutter run

Additional Resources
If you're new to Flutter, here are some resources to help you get started:

Lab: Write your first Flutter app
Cookbook: Useful Flutter samples
Flutter Documentation: Tutorials, samples, and API reference.