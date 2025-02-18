import 'package:flutter/material.dart';
import 'package:object_recognition/res/colors.dart';
import 'package:object_recognition/res/constante.dart';
import 'package:object_recognition/view/camera/components/title_widget.dart';

class ZoomView extends StatefulWidget {
  final double minZoom;
  final double maxZoom;
  final ValueChanged<double> onZoomChanged;

  const ZoomView({
    super.key,
    this.minZoom = 1.0,
    this.maxZoom = 10.0,
    required this.onZoomChanged,
  });

  @override
  State<ZoomView> createState() => _ZoomViewState();
}

class _ZoomViewState extends State<ZoomView> {
  late ScrollController _scrollController;
  double _currentZoom = 1.0;
  final double itemWidth = 40.0; // Largeur d'un segment du slider

  @override
  void initState() {
    super.initState();
    _scrollController =
        ScrollController(initialScrollOffset: _initialScrollOffset());
    _scrollController.addListener(_updateZoomFromScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateZoomFromScroll);
    _scrollController.dispose();
    super.dispose();
  }

  double _initialScrollOffset() {
    return ((widget.maxZoom - widget.minZoom) / 2) * itemWidth;
  }

  void _updateZoomFromScroll() {
    final double scrollOffset = _scrollController.offset;
    final double totalRange = widget.maxZoom - widget.minZoom;
    double newZoom = widget.minZoom + (scrollOffset / itemWidth) % totalRange;
    if (newZoom > widget.maxZoom) {
      newZoom = widget.minZoom;
      _scrollController
          .jumpTo(_initialScrollOffset()); // Réinitialiser le scroll
    }
    setState(() {
      _currentZoom = newZoom;
    });
    widget.onZoomChanged(_currentZoom);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                InkWell(
                  child: Icon(
                    Icons.arrow_drop_down_outlined,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
                Text(
                  '${_currentZoom.toStringAsFixed(1)}x',
                  style: TextStyle(
                      color: secondarytColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            TitleWidget(
              title: "x4 zoom",
            )
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 8),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: fourthColor, width: 0.3)),
          constraints: BoxConstraints(maxWidth: 300, maxHeight: 40),
          width: 300,
          height: 40,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: 1000 * 1000,
            itemBuilder: (context, index) {
              final double zoomValue =
                  widget.minZoom + (index % (widget.maxZoom * 10)) / 10.0;
              final bool isMajorTick = (zoomValue % 1).abs() < 0.01;

              return Center(
                child: Container(
                  width: 2,
                  height: isMajorTick ? 22 : 10,
                  color: isMajorTick ? secondarytColor : fourthColor,
                  margin: const EdgeInsets.only(right: 8),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: deffaultPadding / 4,
        )
      ],
    );
  }
}
