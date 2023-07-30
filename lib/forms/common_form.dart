import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:provider/provider.dart';

import 'package:icd_kaa_olx/forms/user_review_form.dart';

import '../components/common_form_ka_bottom_nav_widget.dart';
import '../components/image_picker_widget.dart';
import '../constants/colors.dart';
import '../constants/validators.dart';
import '../constants/widgets.dart';
import '../provider/category_provider.dart';
import '../services/user.dart';

class CommonForm extends StatefulWidget {
  static const String screenId = 'common_form';
  const CommonForm({Key? key}) : super(key: key);

  @override
  State<CommonForm> createState() => _CommonFormState();
}

class _CommonFormState extends State<CommonForm> {
  //
  UserService firebaseUser = UserService();
  //
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  late FocusNode _descriptionNode;
  late TextEditingController _titleController;
  late FocusNode _titleNode;
  late TextEditingController _priceController;
  late FocusNode _priceNode;
  // THIS IS  ANOUTHER WAY TO DECLARE TEXTEDITNGCONTROLLER, ITS ALSO CORRECT AND WITHOUT LATE KEYWORD IS ALSO CORRECT

  //
  @override
  void initState() {
    _descriptionController = TextEditingController();
    _descriptionNode = FocusNode();
    _titleController = TextEditingController();
    _titleNode = FocusNode();
    _priceController = TextEditingController();
    _priceNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _descriptionNode.dispose();
    _titleController.dispose();
    _titleNode.dispose();
    _priceController.dispose();
    _priceNode.dispose();
    super.dispose();
  }

//***************************************************************************************** */
//***************************************************************************************** */
  @override
  Widget build(BuildContext context) {
    var categoryProvider = Provider.of<CategoryProvider>(context);
    List<String> defaultImage = [
      'https://logos.flamingtext.com/Word-Logos/web-design-china-name.png'
    ];
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: blackColor), //all icons ki theme
          backgroundColor: whiteColor,
          title: Text(
            '${categoryProvider.selectedCategory} Details',
            style: TextStyle(color: blackColor),
          )),
      body: formBodyWidget(context, categoryProvider),
      bottomNavigationBar: BottomNavigationWidget(
        // BOTTOMNAVIGATION BAR ME YE WIDGET KO DALA H, TAKI SCREEN SCROLL KRNE TIME YE WIDGET DFIXED RHE, YE WIDGET NA SCROLL HOE
        buttonText: 'Next',
        validator: true,
        onPressed: () async {
          // IF FORM IS VALIDATORS SATISFIED THEN MAP->categoryProvider.formData ME YE MAP AA JAEGA.
          if (_formKey.currentState!.validate()) {
            categoryProvider.formData.addAll({
              //formData is a just a map associated to categoryProvider and map.addAll func called here
              'seller_uid': firebaseUser.user!.uid,
              'category': categoryProvider.selectedCategory,
              'title': _titleController.text,
              'descr': _descriptionController.text,
              'price': _priceController.text,
              // 'images': categoryProvider.imageUploadedUrls.isEmpty
              //     ? '' //images ka vialidator nai hota to ?: aisa krna pr rha
              //     : categoryProvider.imageUploadedUrls,
              'images': kIsWeb
                  ? defaultImage
                  : categoryProvider.imageUploadedUrls.isNotEmpty
                      ? categoryProvider.imageUploadedUrls
                      : '', //images ka vialidator nai hota to ?: aisa krna pr rha
              'posted_at': DateTime.now().microsecondsSinceEpoch,
              'favourites': [],
              //FAV HAS THOSE PEOPLE'S UIDS WHO HAS LIKED THIS ITEM
              'isDeleted': false
            });
            if (kIsWeb || categoryProvider.imageUploadedUrls.isNotEmpty) {
              Navigator.pushNamed(context, UserFormReview.screenId);
            } else {
              customSnackBar(
                  context: context,
                  content: 'Please upload images to the database');
            }
            debugPrint('${categoryProvider.formData}       😎😎😎😎😎😎😎😎');
          }
        },
      ),
    );
  }

  formBodyWidget(BuildContext context, CategoryProvider categoryProvider) {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding:
                const EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'POST TO SELL HERE',
                  style: TextStyle(
                    color: blackColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 10,
                ),

                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                    controller: _titleController,
                    focusNode: _titleNode,
                    maxLength: 50,
                    validator: (value) {
                      return checkNullEmptyValidation(value, 'title');
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Title*',
                      counterText:
                          'Mention the key features, i.e Brand, Model, Type',
                      labelStyle: TextStyle(
                        color: greyColor,
                        fontSize: 14,
                      ),
                      errorStyle:
                          const TextStyle(color: Colors.red, fontSize: 10),
                      contentPadding: const EdgeInsets.all(15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: disabledColor)),
                    )),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                    controller: _descriptionController,
                    focusNode: _descriptionNode,
                    maxLength: 200,
                    validator: (value) {
                      return checkNullEmptyValidation(
                          value, 'product description');
                    },
                    maxLines: 3,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Description*',
                      counterText: '',
                      labelStyle: TextStyle(
                        color: greyColor,
                        fontSize: 14,
                      ),
                      errorStyle:
                          const TextStyle(color: Colors.red, fontSize: 10),
                      contentPadding: const EdgeInsets.all(15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: disabledColor)),
                    )),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    // web me ek dikkat thi yaha ki input me sirf number dene hote h but yaha laptop ka keyboard se string bhi chala jata so kIsWeb meye onchanged dena pada
                    // app me bhi yehi dikkat thi, ki user comma ya fullstop type krde rhe the users,to database chud ja rha tha kyuki sirf 0-9 hona h idhar
                    onChanged: (value) {
                      // if (kIsWeb) {
                      final selection = _priceController.selection;
                      final from = RegExp(r'[^0-9]');
                      // Regular expression to match non-numeric characters
                      final price = value.replaceAll(from, '');
                      // Replace non-numeric characters with an empty string
                      _priceController.value = _priceController.value.copyWith(
                        text: price,
                        selection: TextSelection.collapsed(
                            offset: selection.baseOffset),
                      );
                      // }
                    },
                    controller: _priceController,
                    focusNode: _priceNode,
                    validator: (value) {
                      return checkNullEmptyValidation(value, 'price');
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefix: const Text('₹ '),
                      labelText: 'Price*',
                      labelStyle: TextStyle(
                        color: greyColor,
                        fontSize: 14,
                      ),
                      errorStyle:
                          const TextStyle(color: Colors.red, fontSize: 10),
                      contentPadding: const EdgeInsets.all(15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: disabledColor)),
                    )),
                const SizedBox(
                  height: 20,
                ),
                //************************************************************************ */
                //siirf android/ios mw image upload hogi here, web me upload nai kr rhe
                //because web me alag image pickerwdget bnana prega vo nai kr rhe ab, as file?picker not works in web,uske liye base64 covert krna padta h image ko for web
                // I am uploading default image for web IN THE IMAGE PICKER WIDGET
                if (!kIsWeb)
                  InkWell(
                    onTap: () async {
                      debugPrint(
                          '${categoryProvider.imageUploadedUrls.length}   <- categoryProvider.imageUploadedUrls.length   😎😎😎😎😎😎');
                      return openBottomSheetWidget(
                          context: context, child: const ImagePickerWidget());
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        color: Colors.grey[300],
                      ),
                      child: Text(
                        categoryProvider.imageUploadedUrls.isNotEmpty
                            ? 'Upload More Images'
                            : 'Upload Image',
                        style: TextStyle(
                            color: blackColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                //************************************************************************ */
                const SizedBox(
                  height: 10,
                ),
                if (categoryProvider.imageUploadedUrls.isNotEmpty)
                  GalleryImage(
                      titleGallery: 'Uploaded Images',
                      numOfShowImages:
                          categoryProvider.imageUploadedUrls.length,
                      imageUrls: categoryProvider.imageUploadedUrls)
                //list of images
              ],
            ),
          ),
        ),
      ),
    );
  }
}
