import 'package:flutter/material.dart';
import 'package:flutter_twitter_image_picker/app/controller/image_picker_controller.dart';
import 'package:get/get.dart';

class ImagePickerView extends StatelessWidget {
  final ImagePickerController imagePickerController = Get.put(ImagePickerController());
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: Color(0XFF15202B),
      appBar: AppBar(
        title: Container(
          width: 180,
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                    hint: Text('Gallery', style: TextStyle(color: Colors.white)),
                    value: imagePickerController.selectedAlbums,
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                    dropdownColor: Color(0XFF15202B),
                    items: imagePickerController.listAlbums.map((value) {
                      return DropdownMenuItem(
                        child: Text(value.name, style: TextStyle(color: Colors.white), overflow: TextOverflow.ellipsis,),
                        value: value,
                      );
                    }).toList(),
                    onChanged: imagePickerController.onChangedAlbums(),
                  ),
            ),
          ),
        ),
        backgroundColor: Color(0XFF15202B),
        brightness: Brightness.dark,
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
          return;
        },
        child: GridView.builder(
            itemCount: imagePickerController.mediaList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisSpacing: 1, crossAxisSpacing: 1),
            itemBuilder: (BuildContext context, int index) {
              return imagePickerController.mediaList[index];
            }),
      ),
    ));
  }
}