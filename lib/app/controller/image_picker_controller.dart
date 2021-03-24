import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:photo_manager/photo_manager.dart';

class ImagePickerController extends GetxController {
  var mediaList = <Widget>[].obs;
  var listAlbums = <AssetPathEntity>[].obs;
  AssetPathEntity selectedAlbums;
  int lastPage;
  int currentPage = 0;
  bool refreshed = false;

  @override
  void onInit() {
    super.onInit();
    _fetchGallery();
  }

  handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        _fetchGallery();
      }
    }
  }

  _fetchGallery() async {
    lastPage = currentPage;
    var result = await PhotoManager.requestPermission();
    if (result) {
      listAlbums.value = await PhotoManager.getAssetPathList(onlyAll: false);
      if (selectedAlbums == null) {
        selectedAlbums = listAlbums.first;
      }
      List<AssetEntity> media =
          await selectedAlbums.getAssetListPaged(currentPage, 60);
      print(media);
      print(listAlbums.length);
      List<Widget> temp = [];
      for (var asset in media) {
        temp.add(
          FutureBuilder(
            future: asset.thumbDataWithSize(200, 200),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done)
                return Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Image.memory(
                        snapshot.data,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Text(
                            'error',
                            style: TextStyle(color: Colors.white),
                          );
                        },
                      ),
                    ),
                    if (asset.type == AssetType.video)
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 5, bottom: 5),
                          child: Icon(
                            Icons.videocam,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                );
              return Container();
            },
          ),
        );
      }
      if (refreshed) {
        mediaList.clear();
        refreshed = false;
      }
      if (mediaList.isEmpty) {
        mediaList.add(Icon(
          Icons.photo_camera_outlined,
          color: Color(0XFF00ACEE),
          size: 30,
        ));
      }
      mediaList.addAll(temp);
      currentPage++;
    } else {
      /// user doesn't give permission 
    }
  }

  onChangedAlbums() {
    return (value) {
      selectedAlbums = value;
      refreshed = true;
      currentPage = 0;
      _fetchGallery();
    };
  }

  @override
  void onClose() {
    super.onClose();
  }
}
