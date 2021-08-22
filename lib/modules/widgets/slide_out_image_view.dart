import 'package:extended_image/extended_image.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:open_chat_flutter/service/state_service.dart';
import 'package:open_chat_flutter/utils/base_view_import.dart';

typedef DoubleClickAnimationListener = void Function();

class SlideOutImageView extends StatefulWidget {
  const SlideOutImageView({Key? key}) : super(key: key);

  @override
  State<SlideOutImageView> createState() => _SlideOutImageViewState();
}

class _SlideOutImageViewState extends State<SlideOutImageView> with TickerProviderStateMixin {
  GlobalKey<ExtendedImageSlidePageState> slidePageKey = GlobalKey<ExtendedImageSlidePageState>();
  GlobalKey key = GlobalKey();
  ImageProvider? imageProvider;
  String? url;
  late AnimationController _doubleClickAnimationController;
  Animation<double>? _doubleClickAnimation;
  late DoubleClickAnimationListener _doubleClickAnimationListener;
  List<double> doubleTapScales = <double>[1.0, 2.0];

  final RxDouble _pageOpacity = 1.0.obs;
  RxBool isDownloading = RxBool(false);

  @override
  void initState() {
    imageProvider = Get.arguments['imageProvider'];
    url = Get.arguments['url'];
    _doubleClickAnimationController = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _doubleClickAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedOpacity(
        opacity: _pageOpacity.value,
        duration: const Duration(milliseconds: 200),
        child: ExtendedImageSlidePage(
          key: slidePageKey,
          child: Container(
            color: Colors.black,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ExtendedImage(
                    image: imageProvider!,
                    enableSlideOutPage: true,
                    mode: ExtendedImageMode.gesture,
                    fit: BoxFit.fitWidth,
                    onDoubleTap: (ExtendedImageGestureState state) {
                      final Offset? pointerDownPosition = state.pointerDownPosition;
                      final double? begin = state.gestureDetails!.totalScale;
                      double end;

                      _doubleClickAnimation?.removeListener(_doubleClickAnimationListener);

                      _doubleClickAnimationController.stop();

                      _doubleClickAnimationController.reset();

                      if (begin == doubleTapScales[0]) {
                        end = doubleTapScales[1];
                      } else {
                        end = doubleTapScales[0];
                      }

                      _doubleClickAnimationListener = () {
                        state.handleDoubleTap(scale: _doubleClickAnimation!.value, doubleTapPosition: pointerDownPosition);
                      };
                      _doubleClickAnimation = _doubleClickAnimationController.drive(Tween<double>(begin: begin, end: end));

                      _doubleClickAnimation!.addListener(_doubleClickAnimationListener);

                      _doubleClickAnimationController.forward();
                    },
                  ),
                ),
                Positioned(
                  top: 50.h,
                  right: 25.w,
                  child: GestureDetector(
                    onTap: () {
                      slidePageKey.currentState?.popPage();
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(5.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: const Icon(Icons.close),
                    ),
                  ),
                ),
                Positioned(
                  top: 50.h,
                  right: 75.w,
                  child: Obx(
                    () => IgnorePointer(
                      ignoring: isDownloading.value,
                      child: GestureDetector(
                        onTap: () async {
                          if (url == null) {
                            showToast('이미지 주소가 올바르지 않습니다.');
                            return;
                          }
                          try {
                            // Saved with this method.
                            isDownloading.value = true;
                            var imageId = await ImageDownloader.downloadImage(url!);
                            if (imageId == null) {
                              showToast('다운로드 실패');
                              isDownloading.value = false;
                              return;
                            } else {
                              showToast('다운로드 성공');
                            }
                            isDownloading.value = false;
                          } on PlatformException catch (error) {
                            lo('image download $error');
                            isDownloading.value = false;
                          }
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(5.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          child: const Icon(Icons.download),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: isDownloading.value,
                    child: const Positioned.fill(
                      child: Center(
                        child: CLoading(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          slideAxis: SlideAxis.both,
          slideType: SlideType.onlyImage,
          resetPageDuration: const Duration(milliseconds: 300),
          onSlidingPage: (state) {
            _pageOpacity.value = (15 / state.offset.distance).clamp(0, 1);
          },
          slideEndHandler: (offset, {ExtendedImageSlidePageState? state, ScaleEndDetails? details}) {
            if (offset.distance > 100.0) {
              return true;
            }
            return false;
          },
          slidePageBackgroundHandler: (offset, pageSize) {
            return Colors.transparent;
          },
        ),
      ),
    );
  }
}
