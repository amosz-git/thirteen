import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:thirteen/colors.dart';
import 'package:thirteen/data/entity/netease/album_detail.dart';
import 'package:thirteen/data/model/play_list_model.dart';
import 'package:thirteen/widgets/imaged_background.dart';

class PhonographScreen extends StatefulWidget {
  const PhonographScreen({Key key}) : super(key: key);
  @override
  _PhonographScreenState createState() => _PhonographScreenState();
}

class _PhonographScreenState extends State<PhonographScreen>
    with SingleTickerProviderStateMixin {
  /// 当前index
  int currentIndex = -1;

  /// 音乐列表
  List<Track> tracks;

  ///状态变化中间参数
  bool indexChanged = false;

  /// 是否正在播放
  bool _playing = false;

  /// 音乐长度
  Duration duration;

  /// 音乐播放进度
  Duration position;

  AnimationController _animationController;
  PageController _pageController;

  final List<StreamSubscription> _subscriptions = List();
  @override
  void initState() {
    super.initState();

    // if (tracks == widget.tracks && currentIndex == widget.initalIndex) return;
    // currentIndex = widget.initalIndex;
    // tracks = widget.tracks;

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 24))
          ..repeat();

    _pageController = PageController(
      initialPage: currentIndex,
    );
  }

  @override
  void didChangeDependencies() {
    final model = Provider.of<PlayListModel>(context);

    tracks = model.tracks;
    currentIndex = model.index;
    // model.playMusics(tracks, currentIndex);
    // var subscriptionPlayerState = model.onPlayerStateChanged.listen((event) {
    //   if (!mounted) return;
    //   bool playing = event == AudioPlayerState.PLAYING;
    //   if (_playing != playing)
    //     setState(() {
    //       _playing = playing;
    //     });
    // });
    // _subscriptions.add(subscriptionPlayerState);
    // var subscriptionPlayerCompletion = model.onPlayerCompletion.listen((event) {
    //   if (!mounted) return;
    //   switch (model.mode) {
    //     case AudioPlayerMode.Cycle:
    //       _pageController.nextPage(
    //           duration: Duration(milliseconds: 800),
    //           curve: Curves.linearToEaseOut);
    //       break;
    //     case AudioPlayerMode.Single:
    //       model.replay();
    //       break;
    //     case AudioPlayerMode.Random:
    //       break;
    //   }
    // });

    // _subscriptions.add(subscriptionPlayerCompletion);

    // var subscriptionPlayerDuration = model.onDurationChanged.listen((event) {
    //   if (!mounted) return;
    //   setState(() {
    //     duration = event;
    //   });
    // });

    // _subscriptions.add(subscriptionPlayerDuration);
    // var subscriptionPlayerPosition =
    //     model.onAudioPositionChanged.listen((event) {
    //   if (!mounted) return;
    //   setState(() {
    //     position = event;
    //   });
    // });

    // _subscriptions.add(subscriptionPlayerPosition);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final animation = Tween(
      begin: 0,
      end: 2 * pi,
    ).animate(_animationController);

    final model = Provider.of<PlayListModel>(context);

    return CupertinoPageScaffold(
      backgroundColor: Colors.colorPrimaryDark,
      // navigationBar:
      //     CupertinoNavigationBar(middle: Text(tracks[currentIndex].al.name)),
      child: Stack(children: <Widget>[
        ImagedBackground(url: tracks[currentIndex].al.picUrl),
        Column(
          children: <Widget>[
            _buildTitle(context, tracks[currentIndex].al.name,
                tracks[currentIndex].ar[0].name),
            Expanded(
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 100),
                    width: double.infinity,
                    height: 297,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/images/placing.png'),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    child: PageView.builder(
                      itemCount: tracks.length,
                      onPageChanged: (ind) {
                        if (!mounted) return;
                        // setState(() {
                        //   currentIndex = ind;
                        //   model.index = ind;
                        //   indexChanged = true;
                        // });
                      },
                      controller: _pageController,
                      itemBuilder: (context, index) => Row(
                        children: <Widget>[
                          Expanded(
                            child: Center(
                              child: index == model.index && _playing
                                  ? AnimatedBuilder(
                                      animation: animation,
                                      builder: (context, child) =>
                                          Transform.rotate(
                                            angle: animation.value,
                                            child: _buildVinylItem(
                                                tracks[index].al.picUrl),
                                          ))
                                  : _buildVinylItem(tracks[index].al.picUrl),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -144,
                    child: Container(
                      width: 321,
                      height: 321,
                      child: AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, child) => Transform.rotate(
                          angle: (indexChanged
                                      ? _pageController.page
                                      : _pageController.initialPage) ==
                                  currentIndex
                              ? 0
                              : -0.3,
                          child: Image.asset('assets/images/styli.png'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    '${position?.toString()?.substring(2, 7) ?? "00:00"}',
                    style: const TextStyle(
                        fontSize: 10, color: Colors.colorPrimary),
                  ),
                ),
                Expanded(
                  child: CupertinoSlider(
                    value: position?.inMilliseconds?.toDouble() ?? 0.0,
                    max: duration?.inMilliseconds?.toDouble() ?? 100.0,
                    onChanged: (double value) {},
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    '${duration?.toString()?.substring(2, 7) ?? "00:00"}',
                    style: const TextStyle(
                        fontSize: 10, color: Colors.colorPrimary),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                      onTap: () => model.previous(),
                      child: Container(
                        width: 58,
                        height: 58,
                        child: Icon(IconData(0xf449,
                            fontFamily: CupertinoIcons.iconFont,
                            fontPackage: CupertinoIcons.iconFontPackage)),
                      )),
                ),
                Expanded(
                  child: GestureDetector(
                      onTap: () => _pageController.previousPage(
                          duration: Duration(milliseconds: 800),
                          curve: Curves.linearToEaseOut),
                      child: Container(
                        width: 58,
                        height: 58,
                        child: Icon(IconData(0xf4aa,
                            fontFamily: CupertinoIcons.iconFont,
                            fontPackage: CupertinoIcons.iconFontPackage)),
                      )),
                ),
                Expanded(
                  child: GestureDetector(
                      // onTap: () => _playing ? model.pause() : model.resume(),
                      child: Container(
                    width: 58,
                    height: 58,
                    child: Icon(_playing
                        ? CupertinoIcons.pause
                        : CupertinoIcons.play_arrow),
                  )),
                ),
                Expanded(
                  child: GestureDetector(
                      onTap: () => _pageController.nextPage(
                          duration: Duration(milliseconds: 800),
                          curve: Curves.linearToEaseOut),
                      child: Container(
                        width: 58,
                        height: 58,
                        child: Icon(IconData(0xf4ac,
                            fontFamily: CupertinoIcons.iconFont,
                            fontPackage: CupertinoIcons.iconFontPackage)),
                      )),
                ),
                Expanded(
                  child: GestureDetector(
                      onTap: () => model.previous(),
                      child: Container(
                        width: 58,
                        height: 58,
                        child: Icon(IconData(0xf421,
                            fontFamily: CupertinoIcons.iconFont,
                            fontPackage: CupertinoIcons.iconFontPackage)),
                      )),
                ),
              ],
            ),
          ],
        ),
      ]),
    );
  }

  ///旋转封面 308-11
  Widget _buildVinylItem(String url) {
    return Container(
      width: 297,
      height: 297,
      // padding: EdgeInsets.all(11),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/disk.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Container(
          width: 202,
          height: 202,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/images/vinyl.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(101)),
            child: Image.network(
              url,
              fit: BoxFit.fill,
              // loadingBuilder: (context,widget,),
            ),
          ),
        ),
      ),
    );
  }

  /// 标题
  Widget _buildTitle(BuildContext context, String name, String artist) =>
      SafeArea(
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                CupertinoIcons.left_chevron,
                color: Colors.colorWhite,
                size: 28,
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text(name,
                        style:
                            TextStyle(color: Colors.colorWhite, fontSize: 14)),
                    Text(artist,
                        style: TextStyle(
                          color: Colors.colorWhite,
                          fontSize: 8,
                        )),
                  ],
                ),
              ),
            ),
            GestureDetector(
              // onTap: () => Navigator.pop(context),
              child: Icon(
                CupertinoIcons.flag,
                color: Colors.colorWhite,
                size: 28,
              ),
            ),
          ],
        ),
      );

  @override
  void dispose() {
    _subscriptions
      ..forEach((element) {
        element.cancel();
      })
      ..clear();
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}
