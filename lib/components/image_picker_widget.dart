import 'dart:io'; //File? _image; isko bnane ke liye
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:image_picker/image_picker.dart'; //  final picker = ImagePicker(); bnane ke liye import kiya ise

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../constants/widgets.dart';
import '../provider/category_provider.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({Key? key}) : super(key: key);

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _image;
  final picker = ImagePicker();
  bool isUploading = false;

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    // NOTE IMAGE.FILE IS NOT SUPPORTED ON FLUTTER WEB, WE CANNOT UPLOAD IMAGES THROUGH WEB ok
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        debugPrint('No Image Selected');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var myCategoryprovider = Provider.of<CategoryProvider>(context);
    return Container(
      color: greyColor,
      height: 320,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        children: [
//************************************************************************************************** */
          (_image == null)
              ? (myCategoryprovider.imageUploadedUrls.isNotEmpty)
                  ? Expanded(
                      child: GalleryImage(
                          titleGallery: 'Uploaded Images',
                          numOfShowImages:
                              myCategoryprovider.imageUploadedUrls.length,
                          imageUrls: myCategoryprovider.imageUploadedUrls),
                    )
                  : Icon(
                      CupertinoIcons.photo_on_rectangle,
                      size: 150,
                      color: disabledColor,
                    )
              : SizedBox(
                  height: 200,
                  child: isUploading
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: secondaryColor,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                                'Uploading your image to the database ...')
                          ],
                        )
                      : Image.file(_image!),
                ),
//************************************************************************************************** */
          const SizedBox(
            height: 20,
          ),
//************************************************************************************************** */
          (_image == null)
              ? Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: getImage,
                            // YE FUNC GALLERY SE IMAGE PICK KREGA AND USKO "_image" me save kr dega
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 20)),
                                backgroundColor:
                                    MaterialStateProperty.all(secondaryColor)),
                            child: const Text('Select Image')),
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                )
              : (isUploading)
                  ? const SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isUploading = true;
                                  uploadFile(context, _image!.path).then((url) {
                                    myCategoryprovider.setImageList(url);
                                    setState(() {
                                      isUploading = false;
                                      _image = null;
                                      Navigator.of(context).pop();
                                    });
                                  });
                                });
                              },
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 20)),
                                  backgroundColor:
                                      MaterialStateProperty.all(blackColor)),
                              child: const Text('Upload Image')),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _image = null;
                                  });
                                },
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 20)),
                                    backgroundColor:
                                        MaterialStateProperty.all(blackColor)),
                                child: const Text('Cancel')))
                      ],
                    ),
        ],
      ),
    );
  }
}

Future<String> uploadFile(BuildContext context, String filePath) async {
  String imageName = 'product_images/${DateTime.now().microsecondsSinceEpoch}';
  String downloadUrl = '';
  final file = File(filePath);
  try {
    await FirebaseStorage.instance.ref(imageName).putFile(file);
    downloadUrl =
        await FirebaseStorage.instance.ref(imageName).getDownloadURL();
    debugPrint(downloadUrl);
  } on FirebaseException catch (e) {
    customSnackBar(context: context, content: e.code);
  }
  return downloadUrl;
}
