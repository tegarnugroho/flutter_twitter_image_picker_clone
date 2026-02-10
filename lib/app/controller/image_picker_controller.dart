import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:photo_manager/photo_manager.dart';

class ImagePickerController extends GetxController {
  var mediaList = <Widget>[].obs;
  var listAlbums = <AssetPathEntity>[].obs;
  var selectedImages = <AssetEntity>[].obs;
  AssetPathEntity? selectedAlbums;
  int? lastPage;
  int currentPage = 0;
  bool refreshed = false;

  Function(Uint8List?)? onLongPressImage;
  Function(List<AssetEntity>)? onImagesSelected;

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

  void toggleImageSelection(AssetEntity asset) {
    if (selectedImages.contains(asset)) {
      selectedImages.remove(asset);
    } else {
      selectedImages.add(asset);
    }
  }

  bool isImageSelected(AssetEntity asset) {
    return selectedImages.contains(asset);
  }

  void clearSelection() {
    selectedImages.clear();
  }

  void onDonePressed() {
    if (onImagesSelected != null && selectedImages.isNotEmpty) {
      onImagesSelected!(selectedImages.toList());
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
          Obx(() => GestureDetector(
            onTap: () => toggleImageSelection(asset),
            onLongPress: () async {
              // Get the full image data for preview
              final data = await asset.originBytes;
              onLongPressImage?.call(data);
            },
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: FutureBuilder(
                    future: asset.thumbnailDataWithOption(
                        ThumbnailOption(size: ThumbnailSize(200, 200))),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Text(
                              'error',
                              style: TextStyle(color: Colors.white),
                            );
                          },
                        );
                      }
                      return Container();
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
                // Selection overlay
                if (isImageSelected(asset))
                  Positioned.fill(
                    child: Container(
                      color: Colors.blue.withValues(alpha: 0.3),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          )),
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
      clearSelection(); // Clear selection when switching albums
      _fetchGallery();
    };
  }
}
