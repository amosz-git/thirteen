import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:thirteen/colors.dart';
import 'package:thirteen/data/entity/netease/album_detail.dart';
import 'package:thirteen/data/model/player_model.dart';
import 'package:thirteen/data/entity/audio_player_status.dart';

class PhonographScreen extends StatefulWidget {
  final List<Track> tracks;
  final int initalIndex;

  const PhonographScreen({Key key, this.tracks, this.initalIndex})
      : super(key: key);
  @override
  _PhonographScreenState createState() => _PhonographScreenState();
}

class _PhonographScreenState extends State<PhonographScreen>
    with SingleTickerProviderStateMixin {
  /// 当前index
  int currentIndex = -1;

  ///状态变化中间参数
  bool indexChanged = false;
  AnimationController _animationController;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initalIndex;

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 24))
          ..repeat();

    _pageController = PageController(
      initialPage: currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final animation = Tween(
      begin: 0,
      end: 2 * pi,
    ).animate(_animationController);

    final model = Provider.of<PlayerModel>(context)
      ..playAlbum(widget.tracks, currentIndex);
    return CupertinoPageScaffold(
      backgroundColor: Colors.colorPrimaryDark,
      navigationBar:
          CupertinoNavigationBar(middle: Text(model.currentOne.name)),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: <Widget>[
                PageView.builder(
                  onPageChanged: (ind) {
                    setState(() {
                      currentIndex = ind;
                      model.index = ind;
                      indexChanged = true;
                    });
                  },
                  controller: _pageController,
                  itemBuilder: (context, index) => Row(
                    children: <Widget>[
                      Expanded(
                        child: Center(
                          child: index == model.index
                              ? AnimatedBuilder(
                                  animation: animation,
                                  builder: (context, child) => Transform.rotate(
                                        angle: animation.value,
                                        child: _buildVinylItem(
                                            widget.tracks[index].al.picUrl),
                                      ))
                              : _buildVinylItem(widget.tracks[index].al.picUrl),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -67,
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
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                      onTap: () => model.previous(),
                      child: Container(
                        child: Icon(CupertinoIcons.heart),
                      )),
                ),
                Expanded(
                  child: GestureDetector(
                      onTap: () => _pageController.previousPage(
                          duration: Duration(milliseconds: 800),
                          curve: Curves.linearToEaseOut),
                      child: Container(
                        child: Icon(CupertinoIcons.left_chevron),
                      )),
                ),
                Expanded(
                  child: GestureDetector(
                      onTap: () => model.status == AudioPlayerStatus.Playing
                          ? model.pause()
                          : model.resume(),
                      child: Container(
                        child: Icon(model.status == AudioPlayerStatus.Playing
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
                        child: Icon(CupertinoIcons.right_chevron),
                      )),
                ),
                Expanded(
                  child: GestureDetector(
                      onTap: () => model.previous(),
                      child: Container(
                        child: Icon(CupertinoIcons.music_note),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///旋转封面
  Widget _buildVinylItem(String url) {
    return Container(
      width: 304,
      height: 304,
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

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}