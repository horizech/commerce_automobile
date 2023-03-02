import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/collection_tree.dart';
import 'package:shop/models/collection_tree_item.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);
  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  OverlayState? overlayState;
  OverlayEntry? overlayEntry;
  bool showOverlay = false;
  bool mouseOver = false;

  final layerLink = LayerLink();
  final List<FocusNode> rootFocusNodes = [];

  final List<Widget> row = [];

  getRow({int level = 0, required CollectionTree tree, required int parent}) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: (tree.roots![parent].children ?? [])
            .map(
              (e) => Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                    // color: Colors.grey[200],
                    child: GestureDetector(
                      child: Column(
                        children: [
                          Text(
                            e.name,
                            style:
                                Theme.of(context).textTheme.headline1!.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                      onTap: () {
                        _unfocusAllNodes();
                        ServiceManager<UpNavigationService>()
                            .navigateToNamed(Routes.products, queryParams: {
                          'collection': '${e.id}',
                        });
                      },
                    ),
                  ),
                  getcolumn(e.children)
                ],
              ),
            )
            .toList(),
      )
    ].toList();
  }

  Widget getcolumn(List<CollectionTreeItem>? collections) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: collections != null
            ? collections
                .map((e) => GestureDetector(
                      onTap: () {
                        _unfocusAllNodes();
                        ServiceManager<UpNavigationService>().navigateToNamed(
                          Routes.products,
                          queryParams: {'collection': '${e.id}'},
                        );
                      },
                      child: Text(
                        e.name,
                        style: Theme.of(context).textTheme.headline1!.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ))
                .toList()
            : [const Text("")],
      ),
    );
  }

  getWidgets(BuildContext context, CollectionTree tree, int index) => [
        Stack(
          children: [
            ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 512,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.pink,
                        blurRadius: 0.0,
                        offset: Offset(0, 0),
                        spreadRadius: 0.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
            ...getRow(tree: tree, parent: index)
          ],
        ),
      ];

  void _showOverlay(
      BuildContext context, CollectionTree tree, int index) async {
    overlayState = Overlay.of(context)!;

    overlayEntry = OverlayEntry(
        maintainState: true,
        builder: (context) {
          return Positioned(
            left: MediaQuery.of(context).size.width * 0.1,
            // index == 0
            //     ? MediaQuery.of(context).size.width * 0.43
            //     : MediaQuery.of(context).size.width * 0.5,
            top: 112,
            // top: MediaQuery.of(context).size.height * 0.09,
            width: MediaQuery.of(context).size.width * 0.8,
            height: 512,
            child: TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  return Colors.transparent;
                }),
              ),
              onPressed: () {},
              onHover: (val) {
                if (mounted) {
                  if (val && showOverlay) {
                    rootFocusNodes[index].requestFocus();
                    mouseOver = true;
                  } else {
                    rootFocusNodes[index].unfocus();
                    mouseOver = false;
                  }
                }
              },
              onFocusChange: (value) {
                _removeOverlay();
              },
              child: getWidgets(context, tree, index)[0],
            ),
          );
        });
    overlayState!.insertAll([overlayEntry!]);
  }

  void _removeOverlay() {
    overlayEntry!.remove();
  }

  void _prepareNodes(StoreState state) {
    rootFocusNodes.clear();
    for (int index = 0; index < state.collectionTree!.roots!.length; index++) {
      rootFocusNodes.add(FocusNode());
      rootFocusNodes[index].addListener(() {
        if (rootFocusNodes[index].hasFocus) {
          _showOverlay(context, state.collectionTree!, index);
        } else {
          _removeOverlay();
        }
      });
    }
  }

  void _unfocusAllNodes() {
    for (var element in rootFocusNodes) {
      if (element.hasFocus) element.unfocus();
    }
    mouseOver = false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreCubit, StoreState>(
      listener: (context, state) {},
      builder: (context, state) {
        _prepareNodes(state);

        return SizedBox(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: state.collectionTree!.roots!
                .asMap()
                .entries
                .map(
                  (entry) => MouseRegion(
                    child: TextButton(
                      focusNode: rootFocusNodes[entry.key],
                      onHover: (val) {
                        if (mounted) {
                          if (val) {
                            rootFocusNodes[entry.key].requestFocus();
                            showOverlay = true;
                          } else if (!mouseOver) {
                            rootFocusNodes[entry.key].unfocus();
                            // mouseOver = false;
                          }
                        }
                      },
                      onPressed: () {},
                      child: Text(entry.value.name),
                    ),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
