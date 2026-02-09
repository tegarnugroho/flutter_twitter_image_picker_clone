import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:photo_manager/photo_manager.dart';

class ImagePickerController extends GetxController {
  var mediaList = <Widget>[].obs;
  var listAlbums = <AssetPathEntity>[].obs;
  AssetPathEntity? selectedAlbums;
  int? lastPage;
  int currentPage = 0;
  bool refreshed = false;

  Function(Uint8List?)? onLongPressImage;

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
    var result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      listAlbums.value = await PhotoManager.getAssetPathList(onlyAll: false);
      if (listAlbums.isEmpty) {
        return; // No albums available
      }
      selectedAlbums ??= listAlbums.first;
      List<AssetEntity> media =
          await selectedAlbums!.getAssetListPaged(page: currentPage, size: 60);
      media = media.reversed.toList();
      if (kDebugMode) {
        print(media);
        print(listAlbums.length);
      }
      List<Widget> temp = [];
      for (var asset in media) {
        temp.add(
          FutureBuilder(
            future: asset.thumbnailDataWithOption(
                ThumbnailOption(size: ThumbnailSize(200, 200))),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return GestureDetector(
                  onLongPress: () => onLongPressImage?.call(snapshot.data),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Image.memory(
                          snapshot.data!,
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
                  ),
                );
              }
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
}
