import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _volumeSubject = BehaviorSubject.seeded(1.0);
  final _speedSubject = BehaviorSubject.seeded(1.0);
  AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    AudioPlayer.setIosCategory(IosCategory.playback);
    _player = AudioPlayer();
    _player
        .setUrl(
            "https://freeuk4.listen2myradio.com/live.mp3?typeportmount=s1_36195_stream_271031766")
        .catchError((error) {
      // catch audio error ex: 404 url, wrong url ...
      print(error);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Audio Player Demos'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<FullAudioPlaybackState>(
                stream: _player.fullPlaybackStateStream,
                builder: (context, snapshot) {
                  final fullState = snapshot.data;
                  final state = fullState?.state;
                  final buffering = fullState?.buffering;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (state == AudioPlaybackState.connecting ||
                          buffering == true)
                        Container(
                          margin: EdgeInsets.all(8.0),
                          width: 64.0,
                          height: 64.0,
                          child: CircularProgressIndicator(),
                        )
                      else if (state == AudioPlaybackState.playing)
                        IconButton(
                          icon: Icon(Icons.pause),
                          iconSize: 64.0,
                          onPressed: _player.pause,
                        )
                      else
                        IconButton(
                          icon: Icon(Icons.play_arrow),
                          iconSize: 64.0,
                          onPressed: _player.play,
                        ),
                      IconButton(
                        icon: Icon(Icons.stop),
                        iconSize: 64.0,
                        onPressed: state == AudioPlaybackState.stopped ||
                                state == AudioPlaybackState.none
                            ? null
                            : _player.stop,
                      ),
                    ],
                  );
                },
              ),
              Text("Volumesssss"),
              StreamBuilder<double>(
                stream: _volumeSubject.stream,
                builder: (context, snapshot) => Slider(
                  divisions: 10,
                  min: 0.0,
                  max: 1.0,
                  value: snapshot.data ?? 1.0,
                  onChanged: (value) {
                    _volumeSubject.add(value);
                    _player.setVolume(value);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final ValueChanged<Duration> onChanged;
  final ValueChanged<Duration> onChangeEnd;

  SeekBar({
    @required this.duration,
    @required this.position,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double _dragValue;

  @override
  Widget build(BuildContext context) {
    return Slider(
      min: 0.0,
      max: widget.duration.inMilliseconds.toDouble(),
      value: _dragValue ?? widget.position.inMilliseconds.toDouble(),
      onChanged: (value) {
        setState(() {
          _dragValue = value;
        });
        if (widget.onChanged != null) {
          widget.onChanged(Duration(milliseconds: value.round()));
        }
      },
      onChangeEnd: (value) {
        _dragValue = null;
        if (widget.onChangeEnd != null) {
          widget.onChangeEnd(Duration(milliseconds: value.round()));
        }
      },
    );
  }
}