# Flutter Twitter Image Picker Clone

A Flutter application that replicates Twitter's image picker interface, allowing users to browse and select images and videos from their device's gallery with a sleek, Twitter-inspired UI.

## Features

- **Album Selection**: Browse through different photo albums on your device
- **Grid View**: Display images and videos in a responsive 3-column grid
- **Multiple Selection**: Tap images to select/deselect multiple items with visual feedback
- **Selection Counter**: Shows the number of selected images in the app bar and header
- **Clear Selection**: Option to clear all selected images at once
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
3. **Select Images**: Tap images to select/deselect them (selected images show a blue overlay with checkmark)
4. **View Selection Count**: The app bar shows "Done (X)" where X is the number of selected images
5. **Clear Selection**: Use the "Clear All" button in the selection header to deselect all images
6. **Confirm Selection**: Tap "Done" to confirm your selection and trigger the callback
7. **Browse Media**: Scroll through your images and videos in the grid view
8. **Preview Images**: Long press any image to see a larger preview
9. **Close**: Tap the close button or outside the preview to dismiss

### Integration Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_twitter_image_picker/main.dart';
import 'package:photo_manager/photo_manager.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('My App')),
        body: Center(
          child: ElevatedButton(
            child: Text('Pick Images'),
            onPressed: () {
              TwitterImagePicker.show(
                context: context,
                onImagesSelected: (List<AssetEntity> selectedImages) {
                  // Handle the selected images here
                  print('Selected ${selectedImages.length} images');
                  // You can now use the selected AssetEntity objects
                  // to get image data, file paths, etc.
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
```

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

<table>
  <tr>
    <td align="center" width="33%">
      <img width="300" height="600" alt="Screenshot 1" src="https://github.com/user-attachments/assets/7550e2d0-6cfe-4c18-9b70-c16f1660eac9" />
      <br>
      <em>Main Gallery View</em>
    </td>
    <td align="center" width="33%">
      <img width="300" height="600" alt="Screenshot 2" src="https://github.com/user-attachments/assets/9bdf7eca-8a49-4fce-a01a-63706cd6be5c" />
      <br>
      <em>Image Selection</em>
    </td>
    <td align="center" width="33%">
      <img width="300" height="600" alt="Screenshot 3" src="https://github.com/user-attachments/assets/07a05e5b-623e-4bfe-a471-c43dd3c919c8" />
      <br>
      <em>Image Preview</em>
    </td>
  </tr>
</table>



