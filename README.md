![logo](FAR-logo.png)

# Flutter App Rebrand

**Flutter App Rebrand** automates the process of rebranding a Flutter application by updating the package name, launcher icon, and app name across both Android and iOS platforms. It ensures a smooth transition when you need to rebrand an app for new clients, products, or design overhauls.

## Features

- **Package Name Update**: Automatically updates the package name for both Android and iOS.
- **Launcher Icon Update**: Replaces the app’s launcher icon with a new one, updating for both platforms.
- **App Name Update**: Changes the app name that is displayed on the device.
- **Directory Structure Refactoring**: Moves the `MainActivity` to the correct new package directory and deletes the old one.
- **iOS Bundle Identifier Update**: Updates the iOS product bundle identifier (`Runner.xcodeproj`).


## What It does?
- [x] Updates AndroidManifest.xml, build.gradle and MainActivity in both Java and Kotlin
- [x] Moves MainActivity to the new package directory structure and deletes old one
- [x] Generate & updates old ic_launcher icons with new ones
- [x] Updates Product Bundle Identifier in iOS (Runner.xcodeproj)
- [x] Generate & updates AppIcons and ImageSets


## How It Works

This package uses a configuration file (`rebrand.json`) to automatically apply all the necessary changes to your Flutter app. Once the configuration file is set up, the rebranding process runs smoothly without the need for manual edits to each platform-specific file.

### Configuration File (`rebrand.json`)

Create a file called `rebrand.json` in your Flutter project's root directory. This file should include the following keys with valid values:
- `packageName`: The new package name (e.g., `com.newcompany.newapp`).
- `launcherIconPath`: Path to the new launcher icon (e.g., `assets/icons/new_launcher_icon.png`).
- `appName`: The new app name (e.g., `NewApp`).

### Example `rebrand.json`:
```json
{
  "packageName": "com.newcompany.newapp",
  "launcherIconPath": "assets/icons/new_launcher_icon.png",
  "appName": "NewApp"
}
```


## How to Use?

Add Flutter App Rebrand to your `pubspec.yaml` in `dev_dependencies:` section.
```yaml
dev_dependencies: 
  flutter_app_rebrand: ^1.0.0
```
or run this command
```bash
flutter pub add -d flutter_app_rebrand
```


Update dependencies
```
flutter pub get
```
Run this command to change the package configurations for both the platforms.

```
dart run flutter_app_rebrand:main rebrand.json
```

where `rebrand.json` is the JSON file that contains the new package name, path to the new launcher icon, and the updated app name.


## Meta

Distributed under the MIT license.

[https://github.com/sarj33t/flutter_app_rebrand](https://github.com/sarj33t/flutter_app_rebrand)

## Contributing

1. Fork the repository: (<https://github.com/sarj33t/flutter_app_rebrand/fork>)
2. Create a new feature branch (`git checkout -b feature/your-feature-name`)
3. Commit your changes with a descriptive message (`git commit -am 'Add new feature: your-feature-name''`)
4. Push to the branch (`git push origin feature/your-feature-name`)
5. Open a Pull Request and submit it for review.