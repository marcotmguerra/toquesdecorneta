import 'package:audioplayers/audioplayers.dart';

class AudioService {
  AudioService._();
  static final AudioService instance = AudioService._();

  final AudioPlayer _player = AudioPlayer();
  String? _playingPath;

  Future<void> toggle(String assetPath) async {
    if (_playingPath == assetPath &&
        _player.state == PlayerState.playing) {
      await _player.stop();
      _playingPath = null;
      return;
    }
    await _player.stop();
    _playingPath = assetPath;
    await _player.play(AssetSource('audios/$assetPath'));
    _player.onPlayerComplete.first.then((_) {
      if (_playingPath == assetPath) _playingPath = null;
    });
  }

  Future<void> stop() async {
    await _player.stop();
    _playingPath = null;
  }

  bool isPlaying(String assetPath) =>
      _playingPath == assetPath && _player.state == PlayerState.playing;

  Stream<PlayerState> get stateStream => _player.onPlayerStateChanged;

  void dispose() => _player.dispose();
}
