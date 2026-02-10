import 'package:flutter/material.dart';
import 'package:flutter_twitter_image_picker/app/view/image_picker_view.dart';
import 'package:get/route_manager.dart';
import 'package:photo_manager/photo_manager.dart';

class App extends StatelessWidget {
  final Function(List<AssetEntity>)? onImagesSelected;

  const App({super.key, this.onImagesSelected});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      enableLog: true,
      home: ImagePickerView(onImagesSelected: onImagesSelected),
      defaultTransition: Transition.fade,
    );
  }
}
