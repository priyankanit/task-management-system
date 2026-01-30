# task_manager_app

This file contains the flutter mobile application for the Task Management System.

## Tech Stack

- Flutter
- Provider (MVVM Architecture)
- Dio (HTTP client)
- flutter_secure_storage

## Features

- User Authentication (Login & Register)
- Secure token storage
- Auto-login on app restart
- Task CRUD operations
- Task status toggle
- Search and filter tasks
- Pull-to-refresh
- Logout functionality


## Run Instructions
```Run on emulator:
flutter run

```Run on Real Android Device:
To run the app on a real Android device:

1. Start the backend server locally

2. Find your machine IP address

3. Build the APK using: flutter build apk --release --dart-define=API_URL=http://<your-local-ip>:3000


## Install dependencies
```bash
flutter pub get