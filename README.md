# Flutter App Rebrand

A Flutter app rebrand involves updating the app’s visual identity, such as changing the package name, launcher icon, alongside any logos or assets. It ensures consistency with the new branding while maintaining the core functionality.

## What It does?
- [x] Updates AndroidManifest.xml, build.gradle and MainActivity in both Java and Kotlin
- [x] Moves MainActivity to the new package directory structure and deletes old one
- [x] Generate & updates old ic_launcher icons with new ones
- [x] Updates Product Bundle Identifier in iOS (Runner.xcodeproj)
- [x] Generate & updates AppIcons and ImageSets

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
Not migrated to null safety yet? use old version like this
```yaml
dev_dependencies: 
  flutter_app_rebrand: ^1.0.0
```


Update dependencies 
```
flutter pub get
```
Run this command to change the package name for both platforms.

```
dart run flutter_app_rebrand:main rebrand.json
```

where `rebrand.json` is the JSON file contains the new package name, path to the new launcher icon, and the updated app name.

## Example rebrand.json File
```
{
  "bundleId": "new.bundle.id",
  "iconPath": "/Users/PATH/TO/ICON/ic_launcher.png",
  "appName": "New App Name"
}
```

## Meta

Distributed under the MIT license.

[https://github.com/sarj33t/flutter_app_rebrand](https://github.com/sarj33t/flutter_app_rebrand)

## Contributing

1. Fork the repository: (<https://github.com/sarj33t/flutter_app_rebrand/fork>)
2. Create a new feature branch (`git checkout -b feature/your-feature-name`)
3. Commit your changes with a descriptive message (`git commit -am 'Add new feature: your-feature-name''`)
4. Push to the branch (`git push origin feature/your-feature-name`)
5. Open a Pull Request and submit it for review.
