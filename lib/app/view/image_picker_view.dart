import 'dart:typed_data';
import 'dart:ui'; // Add this import for ImageFilter
import 'dart:math'; // Add this for min function

import 'package:flutter/material.dart';
import 'package:flutter_twitter_image_picker/app/controller/image_picker_controller.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:photo_manager/photo_manager.dart';

class ImagePickerView extends StatelessWidget {
  final ImagePickerController imagePickerController =
      Get.put(ImagePickerController());
  final Function(List<AssetEntity>)? onImagesSelected;

  ImagePickerView({super.key, this.onImagesSelected});

  @override
  Widget build(BuildContext context) {
    // Set the callback
    imagePickerController.onImagesSelected = onImagesSelected;
    imagePickerController.onLongPressImage = (Uint8List? data) {
      if (data != null) {
        showDialog(
          context: context,
          barrierDismissible: true, // Allow dismissing by tapping outside
          builder: (context) {
            final decoded = img.decodeImage(data);
            double imgWidth = decoded?.width.toDouble() ?? 0;
            double imgHeight = decoded?.height.toDouble() ?? 0;

            // Calculate container size, maintaining aspect ratio and capping at screen
            double screenWidth = MediaQuery.of(context).size.width;
            double screenHeight = MediaQuery.of(context).size.height;
            double maxW = screenWidth * 0.9;
            double maxH = screenHeight * 0.8;

            double containerWidth;
            double containerHeight;

            if (imgWidth > maxW || imgHeight > maxH) {
              double scale = min(maxW / imgWidth, maxH / imgHeight);
              containerWidth = imgWidth * scale;
              containerHeight = imgHeight * scale;
            } else {
              containerWidth = imgWidth;
              containerHeight = imgHeight;
            }

            return BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 10, sigmaY: 10), // Blur the background
              child: Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: EdgeInsets.all(20), // Padding from screen edges
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Stack(
                  children: [
                    // Enhanced preview container
                    Container(
                      width: containerWidth,
                      height: containerHeight,
                      decoration: BoxDecoration(
                        // Increased border radius for a more rounded look
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          // Subtle white border for definition
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        // Match the container's border radius
                        borderRadius: BorderRadius.circular(15),
                        child: Image.memory(
                          data,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    // Close button
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Material(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => Navigator.of(context).pop(),
                          child: const Padding(
                            padding:
                                EdgeInsets.all(3), // ← controls circle size
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
            );
          },
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
              GestureDetector(
                onTap: () => imagePickerController.onDonePressed(),
                child: Obx(() => Center(
                        child: Text(
                      imagePickerController.selectedImages.isNotEmpty
                          ? 'Done (${imagePickerController.selectedImages.length})'
                          : 'Done',
                      style: TextStyle(color: Color(0XFF00ACEE)),
                    ))),
              ),
              SizedBox(width: 10)
            ],
          ),
          body: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scroll) {
              imagePickerController.handleScrollEvent(scroll);
              return true;
            },
            child: Column(
              children: [
                // Selection indicator
                Obx(() => imagePickerController.selectedImages.isNotEmpty
                    ? Container(
                        color: Colors.blue.withValues(alpha: 0.1),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            Text(
                              '${imagePickerController.selectedImages.length} selected',
                              style: TextStyle(color: Colors.white),
                            ),
                            Spacer(),
                            TextButton(
                              onPressed: () =>
                                  imagePickerController.clearSelection(),
                              child: Text(
                                'Clear All',
                                style: TextStyle(color: Color(0XFF00ACEE)),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox.shrink()),
                // Grid view
                Expanded(
                  child: GridView.builder(
                      itemCount: imagePickerController.mediaList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 3,
                          crossAxisSpacing: 3),
                      itemBuilder: (BuildContext context, int index) {
                        return imagePickerController.mediaList[index];
                      }),
                ),
              ],
            ),
          ),
        ));
  }
}
