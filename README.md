# WristSync

WristSync is a cross-platform Flutter app for discovering, connecting to, and managing Bluetooth Low Energy (BLE) smartwatch devices. It includes onboarding, smartwatch selection and scanning, live connection state, device details, watch-face browsing, settings, and help screens.

## Features

- Splash screen and first-run onboarding
- Bluetooth adapter and connection-state monitoring
- Runtime BLE and nearby-device permission handling
- 15-second BLE device scanning
- Filtering of unnamed BLE advertisements
- Nearby devices sorted by signal strength (RSSI)
- Watch selection by device type
- GATT connection and manual disconnection
- Connected-device status and device information
- Light, dark, and system theme modes with persistent preferences
- My Watches, Watch Faces, Settings, and Help sections
- Responsive layout with reusable animated UI widgets

## Screens

| Route | Screen | Purpose |
| --- | --- | --- |
| `/splash` | Splash | App entry and onboarding/session routing |
| `/onboarding` | Onboarding | First-run introduction |
| `/home` | Home | Connection status and main app actions |
| `/selection` | Watch selection | Choose a smartwatch category |
| `/scan` | Device scan | Discover and connect to nearby watches |
| `/device_info` | Device information | View the active BLE connection |
| `/my-watches` | My Watches | View linked-watch information |
| `/watch-faces` | Watch Faces | Browse the watch-face catalog |
| `/settings` | Settings | Configure app appearance |
| `/help` | Help | App guidance and support information |

## Tech Stack

- [Flutter](https://flutter.dev/) and Dart
- [GetX](https://pub.dev/packages/get) for navigation and reactive state management
- [flutter_blue_plus](https://pub.dev/packages/flutter_blue_plus) for BLE scanning and connections
- [permission_handler](https://pub.dev/packages/permission_handler) for runtime permissions
- [shared_preferences](https://pub.dev/packages/shared_preferences) for local settings
- `shimmer` and `loading_animation_widget` for loading states
- Rubik custom font family

## Project Structure

```text
lib/
├── core/
│   ├── constants/
│   ├── services/
│   │   ├── app_settings_service.dart
│   │   └── ble_service.dart
│   ├── theme/
│   ├── utils/
│   └── widgets/
├── features/
│   ├── splash/
│   ├── onboarding/
│   ├── home/
│   ├── selection/
│   ├── scan/
│   ├── device_info/
│   ├── my_watches/
│   ├── watch_faces/
│   ├── settings/
│   └── help/
├── routes/
│   ├── app_pages.dart
│   └── app_routes.dart
└── main.dart
```

## Getting Started

### Prerequisites

- Flutter SDK with Dart support
- Android Studio or VS Code
- A physical Android or iOS device for BLE testing
- Bluetooth enabled on the test device

BLE communication is not supported reliably on standard emulators. Use a physical device whenever possible.

### Install

```bash
git clone https://github.com/Aptafluxx/Wrist-Sync.git
cd Wrist-Sync
flutter pub get
```

### Run

```bash
flutter run
```

To run on a specific connected device:

```bash
flutter devices
flutter run -d <device-id>
```

## Permissions

The app requests the platform permissions needed for Bluetooth scanning and connection. Bluetooth must be enabled in system settings before a scan can begin.

Android and iOS platform configuration files are included under `android/` and `ios/`.

## Testing

Run the Flutter test suite:

```bash
flutter test
```

Analyze the project:

```bash
flutter analyze
```

## Platform Support

The repository contains generated runner projects for Android, iOS, web, Windows, Linux, and macOS. BLE behavior depends on platform support and hardware; Android is the primary development target for the Bluetooth workflow.