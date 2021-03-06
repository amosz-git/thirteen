import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:thirteen/data/entity/audio_player_mode.dart';
import 'package:thirteen/data/entity/netease/album_detail.dart';

class MusicService {
  AudioPlayer _player;
  AudioPlayer get player {
    if (_player == null) _player = AudioPlayer();
    return _player;
  }

  StreamController<int> _indexStream = StreamController();

  /// 播放器当前播放状态
  AudioPlayerState get status => player.state;

  Stream<int> get onIndexChanged => _indexStream.stream;

  /// 播放器状态
  Stream<AudioPlayerState> get onPlayerStateChanged =>
      player.onPlayerStateChanged;

  /// 当前歌曲播放完毕事件
  Stream<void> get onPlayerCompletion => player.onPlayerCompletion;

  /// 总时长
  Stream<Duration> get onDurationChanged => player.onDurationChanged;

  /// 播放进度
  Stream<Duration> get onAudioPositionChanged => player.onAudioPositionChanged;

  List<Track> _tracks;
  List<Track> get tracks => _tracks;

  int _index = 0;

  int get index => _index;

  Track get current => _tracks == null || _index < 0 ? null : _tracks[index];

  set index(int ind) {
    if (_index != ind) {
      _index = ind;
      _indexStream.add(ind);
    }
    play();
  }

  /// 播放器模式
  AudioPlayerMode mode = AudioPlayerMode.Cycle;

  /// 播放歌单
  void playAlbum(List<Track> tracks, int ind) async {
    if (_tracks != tracks || _index != ind) {
      _tracks = tracks;
      _index = ind;
      await player.release();
      play();
    }
  }

  /// 下一首
  void next() async {
    if (_index < _tracks.length - 2) {
      await player.release();
      index++;
    }
  }

  /// 上一首
  void previous() async {
    if (_index > 0) {
      await player.release();
      index--;
    }
  }

  void play() async {
    await player.play(_tracks[_index].songUrl);
  }

  ///重新播放
  void replay() {
    play();
  }

  /// 播放
  void resume() async {
    await player.resume();
  }

  /// 暂停
  void pause() async {
    await player.pause();
  }

  void dispose() async {
    await player.release();
    await player.dispose();
    _indexStream.close();
  }
}
