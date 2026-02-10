# Flutter Twitter Image Picker Clone

A Flutter application that replicates Twitter's image picker interface, allowing users to browse and select images and videos from their device's gallery with a sleek, Twitter-inspired UI.

## Features

- **Album Selection**: Browse through different photo albums on your device
- **Grid View**: Display images and videos in a responsive 3-column grid
- **Image Preview**: Long press any image to view it in a full-screen dialog with blur background
- **Video Support**: Identifies and marks video files with an icon
- **Infinite Scroll**: Automatically loads more media as you scroll
- **Twitter-like UI**: Dark theme with blue accents matching Twitter's design
- **Permission Handling**: Properly requests and handles photo library permissions

## Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/flutter_twitter_image_picker_clone.git
   cd flutter_twitter_image_picker_clone
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

## Usage

1. **Grant Permissions**: The app will request access to your photo library
2. **Select Album**: Use the dropdown in the app bar to switch between different albums
3. **Browse Media**: Scroll through your images and videos in the grid view
4. **Preview Images**: Long press any image to see a larger preview
5. **Close**: Tap the close button or outside the preview to dismiss

## Dependencies

This project uses the following main dependencies:

- **[GetX](https://pub.dev/packages/get)**: State management and navigation
- **[Photo Manager](https://pub.dev/packages/photo_manager)**: Access and manage photo library
- **[Image](https://pub.dev/packages/image)**: Image processing and decoding

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── app/
│   ├── app.dart             # Main app widget with GetMaterialApp
│   ├── controller/
│   │   └── image_picker_controller.dart  # State management logic
│   └── view/
│       └── image_picker_view.dart       # Main UI screen
```

## Development

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)

### Building for Production

```bash
# Build for Android APK
flutter build apk --release

# Build for iOS
flutter build ios --release

# Build for Web
flutter build web --release
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by Twitter's image picker interface
- Built with Flutter

---

Show some love and star the repo to support the project

## Screenshots

<div align="center">
  <img src="https://user-images.githubusercontent.com/35763779/136394621-5b4b4ea5-cace-4550-9b63-f10d113e94f6.jpg" width="400" alt="App Screenshot 1">
  <img src="https://user-images.githubusercontent.com/35763779/136394652-6ec92c27-3246-4d9c-b11a-9a7eab5a22ec.jpg" width="400" alt="App Screenshot 2">
</div>
