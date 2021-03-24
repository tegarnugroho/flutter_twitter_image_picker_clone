import 'package:flutter/material.dart';
import 'package:flutter_twitter_image_picker/app/view/image_picker_view.dart';
import 'package:get/route_manager.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      enableLog: true,
      home: ImagePickerView(),
      defaultTransition: Transition.fade,
    );
  }
}