import 'dart:typed_data';

import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/widgets/up_app_bar.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/isUserAdmin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop/models/media.dart';
import 'package:shop/widgets/drawer/nav_drawer.dart';

import 'package:shop/widgets/media/media_service.dart';
import 'package:shop/widgets/media/media_widget.dart';
import 'package:shop/widgets/store/store_cubit.dart';
import 'package:shop/widgets/unauthorized_widget.dart';

class AdminMedia extends StatefulWidget {
  const AdminMedia({
    Key? key,
  }) : super(key: key);

  @override
  State<AdminMedia> createState() => _AdminMediaState();
}

class _AdminMediaState extends State<AdminMedia> {
  List<Media> media = [];
  TextEditingController nameController = TextEditingController();
  Media selectedMedia = const Media(id: -1, name: "");
  bool isUploading = false;
  @override
  void initState() {
    super.initState();
    getMedia();
  }

  getMedia({String? message}) async {
    media = await MediaService.getAllMedia() ?? [];
    if (media.isNotEmpty) {
      if (message != null && message.isNotEmpty) {
        isUploading = false;
        if (mounted) {
          UpToast().showToast(context: context, text: message);
        }
      }
      setState(() {});
    }
  }

  uploadMedia() async {
    final ImagePicker picker = ImagePicker();

    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      isUploading = true;
      setState(() {});
      await pickedImage.readAsBytes().then((Uint8List list) async {
        APIResult? result =
            await MediaService.uploadMedia(list, pickedImage.name);
        if (result != null && result.success) {
          getMedia(message: result.message);
        }
        return null;
      });
    }
  }

  Widget leftSide() {
    return Container(
      color: Colors.grey[200],
      width: 300,
      height: 900,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            GestureDetector(
                onTap: (() {
                  selectedMedia = const Media(name: "", id: -1);
                  nameController.text = selectedMedia.name;

                  setState(() {});
                }),
                child: Container(
                  color: selectedMedia.id == -1
                      ? UpConfig.of(context).theme.primaryColor[100]
                      : Colors.transparent,
                  child: const ListTile(
                    title: UpText("Create a new media"),
                  ),
                )),
            ...media
                .map(
                  (e) => GestureDetector(
                    onTap: (() {
                      selectedMedia = e;
                      nameController.text = selectedMedia.name;
                      setState(() {});
                    }),
                    child: Container(
                      color: selectedMedia.id == e.id
                          ? UpConfig.of(context).theme.primaryColor[100]
                          : Colors.transparent,
                      child: ListTile(
                        title: UpText(e.name),
                      ),
                    ),
                  ),
                )
                .toList()
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UpAppBar(),
      drawer: const NavDrawer(),
      body: isUserAdmin()
          ? BlocConsumer<StoreCubit, StoreState>(
              listener: (context, state) {},
              builder: (context, state) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    leftSide(),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SizedBox(
                          width: 400,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: UpText(
                                      "Media",
                                      type: UpTextType.heading6,
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: selectedMedia.id == -1,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: 150,
                                          height: 50,
                                          child: UpButton(
                                            text: "Upload Media",
                                            onPressed: () {
                                              uploadMedia();
                                            },
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: isUploading == true,
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: UpCircularProgress(
                                            width: 20,
                                            height: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: selectedMedia.id != -1,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: 200,
                                          height: 200,
                                          child: MediaWidget(
                                            media: selectedMedia,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ]),
                        ),
                      ),
                    )
                  ],
                );
              },
            )
          : const UnAuthorizedWidget(),
    );
  }
}
