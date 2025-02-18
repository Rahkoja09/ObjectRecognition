import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:photo_manager/photo_manager.dart';

class PickImageGallery extends StatefulWidget {
  const PickImageGallery({super.key});

  @override
  State<PickImageGallery> createState() => _PickImageGalleryState();
}

class _PickImageGalleryState extends State<PickImageGallery> {
  final double maxheight = 50;
  final double maxwidth = 50;
  File? _image;
  File? _firstImage;

  @override
  void initState() {
    super.initState();
    _fetchFirstImageFromGallery();
  }

  // Méthode pour ouvrir la galerie et sélectionner une image
  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Convertir en File
      });
    } else {
      print('Aucune image sélectionnée.');
    }
  }

  Future<void> _fetchFirstImageFromGallery() async {
    final PermissionState permission =
        await PhotoManager.requestPermissionExtend();
    if (permission.isAuth) {
      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );

      if (albums.isNotEmpty) {
        final AssetPathEntity firstAlbum = albums.first;
        final List<AssetEntity> media = await firstAlbum.getAssetListRange(
          start: 0,
          end: 1,
        );

        if (media.isNotEmpty) {
          final AssetEntity firstMedia = media.first;
          final File? file = await firstMedia.file;

          if (file != null) {
            setState(() {
              _firstImage = file;
            });
          }
        }
      }
    } else {
      print('Permission refusée');
    }
  }

  @override
  void dispose() {
    _fetchFirstImageFromGallery();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 15,
      left: 10,
      child: InkWell(
        onTap: _pickImageFromGallery,
        child: Container(
          height: maxheight,
          width: maxwidth,
          constraints: BoxConstraints(maxHeight: maxheight, maxWidth: maxwidth),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: _firstImage != null
                  ? FileImage(_firstImage!)
                  : const AssetImage("assets/medias/images/default_image.png")
                      as ImageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
