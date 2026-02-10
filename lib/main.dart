import 'package:flutter/material.dart';
import 'package:flutter_twitter_image_picker/app/app.dart';
import 'package:photo_manager/photo_manager.dart';

void main() => runApp(App());

class TwitterImagePicker {
  static void show({
    required BuildContext context,
    required Function(List<AssetEntity>) onImagesSelected,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => App(onImagesSelected: onImagesSelected),
      ),
    );
  }
}

