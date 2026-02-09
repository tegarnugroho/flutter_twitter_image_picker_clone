import 'dart:typed_data';
import 'dart:ui'; // Add this import for ImageFilter

import 'package:flutter/material.dart';
import 'package:flutter_twitter_image_picker/app/controller/image_picker_controller.dart';
import 'package:get/get.dart';

class ImagePickerView extends StatelessWidget {
  final ImagePickerController imagePickerController =
      Get.put(ImagePickerController());

  ImagePickerView({super.key});

  @override
  Widget build(BuildContext context) {
    imagePickerController.onLongPressImage = (Uint8List? data) {
      if (data != null) {
        showDialog(
          context: context,
          barrierDismissible: true, // Allow dismissing by tapping outside
          builder: (context) => BackdropFilter(
            filter:
                ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Blur the background
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.all(20), // Padding from screen edges
              child: Stack(
                children: [
                  // Enhanced preview container
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.9,
                      maxHeight: MediaQuery.of(context).size.height * 0.8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.memory(
                        data,
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                  // Close button
                  Positioned(
                    top: 50,
                    right: 10,
                    child: Material(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => Navigator.of(context).pop(),
                        child: const Padding(
                          padding: EdgeInsets.all(3), // ← controls circle size
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    };

    return Obx(() => Scaffold(
          backgroundColor: Color(0XFF15202B),
          appBar: AppBar(
            title: SizedBox(
              width: 180,
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                    hint:
                        Text('Gallery', style: TextStyle(color: Colors.white)),
                    value: imagePickerController.selectedAlbums,
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                    dropdownColor: Color(0XFF15202B),
                    items: imagePickerController.listAlbums.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(
                          value.name,
                          style: TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: imagePickerController.onChangedAlbums(),
                  ),
                ),
              ),
            ),
            backgroundColor: Color(0XFF15202B),
            elevation: 1,
            titleSpacing: 5,
            leading: IconButton(
              onPressed: () {},
              icon: Icon(Icons.close, color: Color(0XFF00ACEE)),
            ),
            actions: [
              Center(
                  child: Text(
                'Done',
                style: TextStyle(color: Color(0XFF00ACEE)),
              )),
              SizedBox(width: 10)
            ],
          ),
          body: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scroll) {
              imagePickerController.handleScrollEvent(scroll);
              return true;
            },
            child: GridView.builder(
                itemCount: imagePickerController.mediaList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, mainAxisSpacing: 3, crossAxisSpacing: 3),
                itemBuilder: (BuildContext context, int index) {
                  return imagePickerController.mediaList[index];
                }),
          ),
        ));
  }
}
