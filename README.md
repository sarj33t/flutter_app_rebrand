![FARLogo](https://raw.githubusercontent.com/sarj33t/flutter_app_rebrand/main/FAR-logo.png)

# Flutter App Rebrand

**Flutter App Rebrand** automates the process of rebranding a Flutter application by updating the package name, launcher icon, and app name across both Android and iOS platforms. It ensures a smooth transition when you need to rebrand an app for new clients, products, or design overhauls.

---

## Features

- **Package Name Update**: Automatically updates the package name for both Android and iOS.
- **Launcher Icon Update**: Replaces the app’s launcher icon with a new one, updating for both platforms.
- **App Name Update**: Changes the app name that is displayed on the device.
- **Directory Structure Refactoring**: Moves the `MainActivity` to the correct new package directory and deletes the old one.
- **iOS Bundle Identifier Update**: Updates the iOS product bundle identifier (`Runner.xcodeproj`).
- **iOS Archive Name Update**: This package also updates the generated archive name as per the provided appName

---

## What It does?
- [x] Updates AndroidManifest.xml, build.gradle and MainActivity in both Java and Kotlin
- [x] Moves MainActivity to the new package directory structure and deletes old one
- [x] Generate & updates old ic_launcher icons with new ones
- [x] Updates Product Bundle Identifier in iOS (Runner.xcodeproj)
- [x] Generate & updates AppIcons and ImageSets

---

## How It Works

This package uses a configuration file (`rebrand_config.json`) to automatically apply all the necessary changes to your Flutter app. Once the configuration file is set up, the rebranding process runs smoothly without the need for manual edits to each platform-specific file.

---

## Installation

Add the `flutter_app_rebrand` package to your project by including it in your `pubspec.yaml` file under`dev_dependencies:` section.

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

---

## Usage

### Step 1: Define Your Input Configuration (Manually creating json file)

Create a JSON configuration file in your project's root directory, such as `rebrand_config.json`, with the following structure:

```json
{
  "ios": {
    "packageName": "com.sarj33t.ios",
    "launcherIconPath": "../FAR-logo.png",
    "appName": "Panda iOS"
  },
  "android": {
    "packageName": "com.sarj33t.android",
    "launcherIconPath": "../FAR-logo.png",
    "appName": "Panda Droid"
  }
}
```
**Configuration Details:**
###### iOS:
- packageName: Unique bundle identifier for the iOS app.
- launcherIconPath: Path to the iOS launcher icon file.
- appName: Display name for the iOS app.

###### Android:
- packageName: Unique package name for the Android app.
- launcherIconPath: Path to the Android launcher icon file.
- appName: Display name for the Android app.

**Notes:**
- The configuration can be platform-specific or identical for both iOS and Android.
- Ensure the launcherIconPath points to a valid image file relative to the configuration file.

---

### Step 2: Generate Configuration File using command (Auto Generate json file)

Run the following command in your terminal:
```
dart run flutter_app_rebrand:build
```

This command will generate the `rebrand_config.json` JSON file that contains the new package name, path to the new launcher icon, and the updated app name.

---

## About the Author

- For more projects, tutorials, and resources, visit my website: [sarj33t.com](https://sarj33t.com)

---

## YouTube Video Guide

For a step-by-step video guide on how to use **Flutter App Rebrand**, watch this YouTube video:

[![Watch the video](https://img.youtube.com/vi/qMqxev7-gV4/maxresdefault.jpg)](https://www.youtube.com/watch?v=qMqxev7-gV4)


---

## Meta

Distributed under the MIT license.

[https://github.com/sarj33t/flutter_app_rebrand](https://github.com/sarj33t/flutter_app_rebrand)

---

## Contributing

1. Fork the repository: (<https://github.com/sarj33t/flutter_app_rebrand/fork>)
2. Create a new feature branch (`git checkout -b feature/your-feature-name`)
3. Commit your changes with a descriptive message (`git commit -am 'Add new feature: your-feature-name''`)
4. Push to the branch (`git push origin feature/your-feature-name`)
5. Open a Pull Request and submit it for review.

---

## Support

If you find my work useful and would like to support me, you can buy me a coffee! ☕️

[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-FFDD00?style=flat-square&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/sarj33t)
