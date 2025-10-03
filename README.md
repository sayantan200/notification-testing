# Flutter Notification App

A cross-platform Flutter application that demonstrates local notifications with scheduling capabilities for Android, iOS, and Web platforms.

## Features

- **Immediate Notifications** - Show notifications instantly
- **Scheduled Notifications** - Schedule notifications for specific times
- **Test Notifications** - 10-second and 30-second test notifications
- **Multiple Notifications** - Support for multiple simultaneous notifications
- **Cross-Platform Support** - Works on Android, iOS, and Web
- **Permission Handling** - Automatic permission requests for all platforms
- **Background Processing** - Notifications work when app is in background

## Screenshots

The app provides a simple interface with buttons to test various notification scenarios:
- Show immediate notifications
- Schedule notifications for specific times
- Test short-duration notifications (10s, 30s)
- Check pending notifications
- Cancel all scheduled notifications

## Platform Support

### Android
- ✅ Local notifications with exact timing
- ✅ Background processing
- ✅ Android 13+ notification permissions
- ✅ Android 14+ exact alarm permissions
- ✅ High priority notifications

### iOS
- ✅ Local notifications with proper delegates
- ✅ Background processing support
- ✅ Sound, badge, and alert notifications
- ✅ Permission handling
- ✅ Notification center integration

### Web
- ✅ Fallback to SnackBar notifications
- ✅ Browser notification support (with permission)
- ✅ Cross-platform compatibility

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_local_notifications: ^19.4.2
  timezone: ^0.10.1
  flutter_timezone: ^4.1.1
  cupertino_icons: ^1.0.8
```

## Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/flutter-notification-app.git
   cd flutter-notification-app
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

## Configuration

### Android Configuration
The app automatically handles Android permissions and configurations:
- Notification channels are created automatically
- Exact alarm permissions are requested for Android 14+
- Background processing is enabled

### iOS Configuration
iOS configuration includes:
- Proper notification delegates in AppDelegate.swift
- Background modes for notifications
- Permission requests for alerts, badges, and sounds

### Web Configuration
Web notifications fallback to SnackBar for testing, with proper browser notification support.

## Usage

### Basic Notifications
```dart
// Show immediate notification
await Notice().showNotification(
  title: 'Hello',
  body: 'This is a test notification',
);

// Schedule notification for specific time
await Notice().scheduleNotification(
  title: 'Scheduled Notification',
  body: 'This is scheduled',
  hour: 14,
  minute: 30,
);

// Schedule notification with delay
await Notice().scheduleNotificationWithDelay(
  title: 'Delayed Notification',
  body: 'This will appear in 10 seconds',
  delay: Duration(seconds: 10),
);
```

### Testing Features
- **10-Second Test** - Tests short-duration notifications
- **30-Second Test** - Tests slightly longer notifications
- **Check Pending** - View all scheduled notifications
- **Cancel All** - Clear all scheduled notifications

## Project Structure

```
lib/
├── main.dart              # App entry point
├── home_page.dart         # Main UI with test buttons
└── notice.dart           # Notification service class

ios/
├── Runner/
│   ├── AppDelegate.swift  # iOS notification delegates
│   └── Info.plist        # iOS permissions and background modes

android/
└── app/src/main/
    └── AndroidManifest.xml  # Android permissions
```

## Key Features Implemented

### Notification Service (`notice.dart`)
- Singleton pattern for global access
- Cross-platform initialization
- Permission handling for all platforms
- Multiple scheduling methods
- Pending notification management

### UI Components (`home_page.dart`)
- Test buttons for various scenarios
- Immediate notification testing
- Scheduled notification testing
- Pending notification checking
- Notification cancellation

### Platform-Specific Configuration
- **Android**: Manifest permissions, exact alarms, notification channels
- **iOS**: AppDelegate delegates, Info.plist background modes
- **Web**: Fallback notifications, browser compatibility

## Troubleshooting

### Common Issues

1. **Notifications not showing on Android:**
   - Check if notification permissions are granted
   - Verify exact alarm permissions for Android 14+
   - Ensure app is not in battery optimization mode

2. **iOS notifications not working:**
   - Check if notification permissions are granted in Settings
   - Verify background app refresh is enabled
   - Ensure proper delegate setup in AppDelegate.swift

3. **Web notifications:**
   - Browser may block notifications - check browser settings
   - HTTPS is required for browser notifications
   - Fallback to SnackBar notifications for testing

## Development

### Running Tests
```bash
flutter test
```

### Building for Production
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on multiple platforms
5. Submit a pull request

## License

This project is open source and available under the [MIT License](LICENSE).

## Acknowledgments

- Flutter Local Notifications plugin
- Timezone package for scheduling
- Flutter team for cross-platform support