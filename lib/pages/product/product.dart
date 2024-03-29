import 'dart:typed_data';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_icon.dart';
import 'package:flutter_up/widgets/up_orientational_column_row.dart';
import 'package:flutter_up/widgets/up_scaffold.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/attribute.dart';
import 'package:shop/models/attribute_value.dart';
import 'package:shop/models/keyword.dart';
import 'package:shop/models/media.dart';
import 'package:shop/models/product.dart';
import 'package:intl/intl.dart';
import 'package:shop/widgets/appbar/automobile_appbar.dart';
import 'package:shop/widgets/drawer/menu_drawer.dart';
import 'package:shop/widgets/error/error.dart';
import 'package:shop/widgets/media/media_service.dart';
import 'package:shop/services/product_detail_service.dart';
import 'package:shop/widgets/store/store_cubit.dart';
import 'package:video_player/video_player.dart';

class ProductPage extends StatelessWidget {
  final Map<String, String>? queryParams;
  const ProductPage({Key? key, this.queryParams}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int? productId;
    if (queryParams != null &&
        queryParams!.isNotEmpty &&
        queryParams!['productId'] != null &&
        queryParams!['productId']!.isNotEmpty) {
      productId = int.parse(queryParams!['productId']!);
    }
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return UpScaffold(
      scaffoldKey: scaffoldKey,
      drawer: const MenuDrawer(),
      appBar: AutomobileAppbar(
        scaffoldKey: scaffoldKey,
      ),
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      body: productId != null
          ? FutureBuilder<Product?>(
              future: ProductDetailService.getProductById(productId),
              builder:
                  (BuildContext context, AsyncSnapshot<Product?> snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const UpCircularProgress(
                    width: 30,
                    height: 30,
                  );
                }
                if (snapshot.connectionState != ConnectionState.done) {
                  return const UpCircularProgress(
                    width: 30,
                    height: 30,
                  );
                }

                return snapshot.hasData && snapshot.data != null
                    ? SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ProductDetailedInfo(
                              product: snapshot.data!,
                            ),
                          ],
                        ),
                      )
                    : const NotFoundErrorWidget();
              },
            )
          : const NotFoundErrorWidget(),
    );
  }
}

class ProductDetailedInfo extends StatefulWidget {
  final Product product;
  final int? collection;

  const ProductDetailedInfo({
    Key? key,
    required this.product,
    this.collection,
  }) : super(key: key);

  @override
  State<ProductDetailedInfo> createState() => _ProductDetailedInfoState();
}

class _ProductDetailedInfoState extends State<ProductDetailedInfo> {
  List<Keyword> keywords = [];
  List<int> mediaList = [];
  List<Attribute> attributes = [];
  List<AttributeValue> attributeValues = [];

  @override
  Widget build(BuildContext context) {
    try {
      return BlocConsumer<StoreCubit, StoreState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.gallery != null && state.gallery!.isNotEmpty) {
            mediaList = state.gallery!
                .where((element) => element.id == widget.product.gallery)
                .first
                .mediaList;
          }
          if (state.keywords != null && state.keywords!.isNotEmpty) {
            for (var keyword in widget.product.keywords!) {
              keywords.add(
                state.keywords!.where((element) => element.id == keyword).first,
              );
            }
          }
          if (state.attributes != null && state.attributes!.isNotEmpty) {
            attributes = state.attributes!.toList();
          }
          if (state.attributeValues != null &&
              state.attributeValues!.isNotEmpty) {
            attributeValues = state.attributeValues!.toList();
          }
          NumberFormat numberFormat = NumberFormat.decimalPattern();
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UpOrientationalColumnRow(
                    children: [
                      Visibility(
                        visible: mediaList.isNotEmpty,
                        child: GetMedia(
                          mediaList: mediaList,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),
                          UpText(
                            widget.product.name,
                            style: UpStyle(
                              textSize: 25,
                              textWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          UpText(
                            "£ ${numberFormat.format(widget.product.price).toString()}",
                            style: UpStyle(
                              textSize: 20,
                              // textWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DottedLine(
                              dashColor:
                                  UpConfig.of(context).theme.baseColor.shade400,
                            ),
                          ),
                          Visibility(
                            visible: keywords.isNotEmpty,
                            child: Wrap(
                                children: keywords
                                    .map((e) => Wrap(
                                          children: [
                                            UpIcon(
                                              icon: Icons.check,
                                              style: UpStyle(iconSize: 16),
                                            ),
                                            UpText(
                                              e.name,
                                              style: UpStyle(textSize: 16),
                                            )
                                          ],
                                        ))
                                    .toList()),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              child: Visibility(
                                visible: widget.product.description != null &&
                                    widget.product.description!.isNotEmpty,
                                child: UpText(
                                  widget.product.description ?? "",
                                  style: UpStyle(textSize: 16),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: UpButton(
                                onPressed: () {},
                                style: UpStyle(
                                  isRounded: true,
                                  borderRadius: 4,
                                ),
                                text: "Contact Us",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _ProductDetail(
                              product: widget.product,
                              attributes: attributes,
                              attributeValues: attributeValues,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}

class _ProductDetail extends StatefulWidget {
  final Product product;
  final List<Attribute>? attributes;
  final List<AttributeValue>? attributeValues;
  const _ProductDetail({
    Key? key,
    required this.product,
    required this.attributeValues,
    required this.attributes,
  }) : super(key: key);

  @override
  State<_ProductDetail> createState() => __ProductDetail();
}

class __ProductDetail extends State<_ProductDetail> {
  int view = 1;

  Widget getDetailRow(String key) {
    key;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: widget.product.options != null &&
              key.isNotEmpty &&
              widget.product.options![key] != null &&
              widget.attributes != null &&
              widget.attributes!.isNotEmpty &&
              widget.attributeValues != null &&
              widget.attributeValues!.isNotEmpty &&
              widget.attributes!.any((element) => element.id == int.parse(key))
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    UpText(
                      "${widget.attributes!.where((element) => element.id == int.parse(key)).first.name.toString()} : ",
                      style: UpStyle(
                        textSize: 16,
                      ),
                    ),
                    UpText(
                        widget.attributeValues!
                            .where((element) =>
                                element.id == widget.product.options![key])
                            .first
                            .name
                            .toString(),
                        style: UpStyle(
                          textSize: 14,
                          // textColor: UpConfig.of(context).theme.primaryColor[400]),
                        )),
                  ],
                ),
              ],
            )
          : const SizedBox(),
    );
  }

  Widget financeView() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: SizedBox(
        child: UpText(
          "Finance",
        ),
      ),
    );
  }

  Widget performanceView() {
    return widget.product.meta!["Performance"] != null
        ? SizedBox(
            child: Visibility(
              visible:
                  (widget.product.meta!["Performance"] as Map<String, dynamic>)
                      .isNotEmpty,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: ((widget.product.meta!["Performance"]
                        as Map<String, dynamic>)
                    .keys
                    .map((key) => SizedBox(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Visibility(
                            visible: automobilePerformance.containsKey(key),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  child: UpText(
                                    automobilePerformance[key].toString(),
                                    style: UpStyle(
                                      textWeight: FontWeight.bold,
                                      textSize: 14,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  child: UpText(
                                    (widget.product.meta!["Performance"]
                                            as Map<String, dynamic>)[key]
                                        .toString(),
                                    style: UpStyle(
                                      textSize: 14,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )))
                    .toList()),
              ),
            ),
          )
        : const SizedBox();
  }

  Widget featuresView() {
    return widget.product.meta!["Features"] != null
        ? SizedBox(
            child: Visibility(
              visible:
                  (widget.product.meta!["Features"] as Map<String, dynamic>)
                      .isNotEmpty,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    ((widget.product.meta!["Features"] as Map<String, dynamic>)
                        .keys
                        .map((key) => SizedBox(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Visibility(
                                visible: automobileFeatures.containsKey(key),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      child: UpText(
                                        automobileFeatures[key].toString(),
                                        style: UpStyle(
                                          textWeight: FontWeight.bold,
                                          textSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        child: UpIcon(
                                      icon: (widget.product.meta!["Features"]
                                              as Map<String, dynamic>)[key]
                                          ? Icons.check
                                          : Icons.cancel,
                                      style: UpStyle(
                                        iconSize: 20,
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                            )))
                        .toList()),
              ),
            ),
          )
        : const SizedBox();
  }

  Widget detailView() {
    return widget.product.options != null
        ? SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.product.options!.entries
                  .where((element) =>
                      element.key.length == 1 && element.value != null)
                  .map((value) => SizedBox(
                        child: getDetailRow(value.key),
                      ))
                  .toList(),
            ),
          )
        : const SizedBox();
  }

  Widget getView() {
    if (view == 2) {
      return financeView();
    } else if (view == 3) {
      return performanceView();
    } else if (view == 4) {
      return featuresView();
    } else if (view == 5) {
      return galleryView();
    } else {
      return detailView();
    }
  }

  onViewChange(int id) {
    setState(() {
      view = id;
    });
  }

  galleryView() {
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Wrap(
            spacing: 4,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    onViewChange(1);
                  },
                  child: UpText(
                    "Detail",
                    style: UpStyle(
                      textWeight:
                          view == 1 ? FontWeight.bold : FontWeight.normal,
                      textSize: 12,
                    ),
                  ),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    onViewChange(4);
                  },
                  child: UpText(
                    "Features",
                    style: UpStyle(
                      textWeight:
                          view == 4 ? FontWeight.bold : FontWeight.normal,
                      textSize: 12,
                    ),
                  ),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    onViewChange(3);
                  },
                  child: UpText(
                    "Performance",
                    style: UpStyle(
                      textWeight:
                          view == 3 ? FontWeight.bold : FontWeight.normal,
                      textSize: 12,
                    ),
                  ),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    onViewChange(5);
                  },
                  child: UpText(
                    "Gallery",
                    style: UpStyle(
                      textWeight:
                          view == 5 ? FontWeight.bold : FontWeight.normal,
                      textSize: 12,
                    ),
                  ),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    onViewChange(2);
                  },
                  child: UpText(
                    "Finance",
                    style: UpStyle(
                      textWeight:
                          view == 2 ? FontWeight.bold : FontWeight.normal,
                      textSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          child: getView(),
        )
      ],
    );
  }
}

class GetMedia extends StatelessWidget {
  final List<int> mediaList;
  const GetMedia({Key? key, required this.mediaList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Media>>(
      future: MediaService.getMediaByList(mediaList),
      builder: (BuildContext context, AsyncSnapshot<List<Media>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
              child: SizedBox(
            child: Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "automobilelogo.png",
                    height: 100,
                    width: 150,
                  ),
                  const UpText("Loading...")
                ],
              ),
            ),
          ));
        }
        return snapshot.hasData
            ? ProductMediaWidget(
                mediaList: snapshot.data!,
              )
            : const CircularProgressIndicator();
      },
    );
  }
}

class ProductMediaWidget extends StatefulWidget {
  const ProductMediaWidget({
    Key? key,
    required this.mediaList,
  }) : super(key: key);

  final List<Media> mediaList;

  @override
  ProductMediaWidgetState createState() => ProductMediaWidgetState();
}

class ProductMediaWidgetState extends State<ProductMediaWidget> {
  int selectedImage = 0;
  String type = ".mp4";
  getMediaType(int index) {
    if (widget.mediaList[index].url != null &&
        widget.mediaList[index].url!.isNotEmpty) {
      type = (widget.mediaList[index].url!.split("?")).first.split(".").last;
    }
  }

  @override
  void initState() {
    super.initState();
    getMediaType(0);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Column(
        children: [
          SizedBox(
            width: 400,
            child: AspectRatio(
              aspectRatio: 1,
              child: Hero(
                tag: widget.mediaList[selectedImage].id.toString(),
                child: widget.mediaList[selectedImage].img != null &&
                        widget.mediaList[selectedImage].img!.isNotEmpty
                    ? type == "mp4"
                        ? const VideoWidget(video: "")
                        : Image.memory(
                            Uint8List.fromList(
                                widget.mediaList[selectedImage].img!),
                            gaplessPlayback: true,
                          )
                    : type == "mp4"
                        ? const VideoWidget(video: "")
                        : FadeInImage.assetNetwork(
                            placeholder: "assets/loading.gif",
                            image: widget.mediaList[selectedImage].url!,
                          ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(widget.mediaList.length,
                    (index) => buildSmallProductPreview(index)),
              ],
            ),
          )
        ],
      ),
    );
  }

  GestureDetector buildSmallProductPreview(int index) {
    const kPrimaryColor = Color(0xFFFF8F00);
    return GestureDetector(
      onTap: () {
        getMediaType(index);
        setState(() {
          selectedImage = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(8),
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: kPrimaryColor.withOpacity(selectedImage == index ? 1 : 0)),
        ),
        child: widget.mediaList[selectedImage].img != null &&
                widget.mediaList[selectedImage].img!.isNotEmpty
            ? Image.memory(
                Uint8List.fromList(widget.mediaList[index].img!),
                gaplessPlayback: true,
              )
            : FadeInImage.assetNetwork(
                placeholder: "assets/loading.gif",
                image: widget.mediaList[index].url!,
              ),
      ),
    );
  }
}

class VideoWidget extends StatefulWidget {
  final String video;
  const VideoWidget({super.key, required this.video});

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    );

    _initializeVideoPlayerFuture = _controller.initialize();

    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              VideoPlayer(_controller),
              GestureDetector(
                onTap: (() {
                  setState(() {
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      _controller.play();
                    }
                  });
                }),
                child: Align(
                  alignment: Alignment.center,
                  child: UpIcon(
                    icon: _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
