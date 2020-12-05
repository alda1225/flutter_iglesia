import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_church/src/pages/page_subirImagen.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import 'package:flutter_church/src/constant/constantes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'listado_imagenes.dart';

class HomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    AudioPlayer.setIosCategory(IosCategory.playback);
    _player = AudioPlayer();
    _player
        .setUrl(
            "https://freeuk4.listen2myradio.com/live.mp3?typeportmount=s1_36195_stream_808597426")
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

  final _volumeSubject = BehaviorSubject.seeded(1.0);
  final _speedSubject = BehaviorSubject.seeded(1.0);

  int currentPage = 1;
  GlobalKey bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0XFFF6F8FA)),
        child: Center(
          child: _getPage(currentPage),
        ),
      ),
      bottomNavigationBar: FancyBottomNavigation(
        barBackgroundColor: Colors.black54,
        activeIconColor: Colors.black,
        tabs: [
          TabData(
              iconData: Icons.photo_size_select_actual,
              title: "Galeria",
              onclick: () {
                final FancyBottomNavigationState fState =
                    bottomNavigationKey.currentState;
                fState.setPage(2);
              }),
          TabData(
              iconData: Icons.radio,
              title: "Radio",
              onclick: () {
                final FancyBottomNavigationState fState =
                    bottomNavigationKey.currentState;
                fState.setPage(1);
              }),
          //TabData(iconData: Icons.home, title: "Inicio"),
          TabData(
              iconData: Icons.calendar_today,
              title: "Calendario",
              onclick: () {
                final FancyBottomNavigationState fState =
                    bottomNavigationKey.currentState;
                fState.setPage(3);
              }),
        ],
        initialSelection: 1,
        key: bottomNavigationKey,
        onTabChangedListener: (position) {
          setState(() {
            currentPage = position;
          });
        },
      ),
    );
  }

  _getPage(int page) {
    Size size = MediaQuery.of(context).size;
    switch (page) {
      case 0:
        return
          ImagenUpload();
      case 1:
        return Column(
          children: <Widget>[
            Container(
              height: size.height * 0.7,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      left: kDefaultPadding,
                      right: kDefaultPadding,
                      bottom: 36 + kDefaultPadding,
                    ),
                    height: size.height * 0.7 - 27,
                    decoration: BoxDecoration(
                      image: new DecorationImage(
                        colorFilter: new ColorFilter.mode(
                            Colors.black.withOpacity(0.3), BlendMode.dstATop),
                        image: new AssetImage('assets/radio.jpg'),
                        fit: BoxFit.cover,
                      ),
                      color: Colors.black87,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(36),
                        bottomRight: Radius.circular(36),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 250,
                    left: 0,
                    right: 0,
                    child: GestureDetector(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: "RADIO\n" + "\n",
                                style: Theme.of(context).textTheme.display1),
                            TextSpan(
                                text: "LA COSECHA\n" + "\n",
                                style: Theme.of(context).textTheme.display1),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 75,
                    left: 0,
                    right: 0,
                    child: StreamBuilder<double>(
                      stream: _volumeSubject.stream,
                      builder: (context, snapshot) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              FontAwesomeIcons.volumeMute,
                              size: 24.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 90,
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Colors.amber[700],
                                  inactiveTrackColor: Colors.amber[100],
                                  trackShape: CustomTrackShape(),
                                  trackHeight: 5.0,
                                  thumbColor: Colors.yellow[600],
                                  thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: 15.0),
                                  overlayColor:
                                      Colors.yellow[600].withAlpha(32),
                                  overlayShape: RoundSliderOverlayShape(
                                      overlayRadius: 28.0),
                                ),
                                child: Slider(
                                  min: 0.0,
                                  max: 1.0,
                                  value: snapshot.data ?? 1.0,
                                  onChanged: (value) {
                                    _volumeSubject.add(value);
                                    _player.setVolume(value);
                                  },
                                ),
                              ),
                            ),
                            Icon(
                              FontAwesomeIcons.volumeUp,
                              size: 24.0,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 180,
                    left: 0,
                    right: 0,
                    child: StreamBuilder<FullAudioPlaybackState>(
                      stream: _player.fullPlaybackStateStream,
                      builder: (context, snapshot) {
                        final fullState = snapshot.data;
                        final state = fullState?.state;
                        final buffering = fullState?.buffering;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (state == AudioPlaybackState.connecting ||
                                buffering == true)
                              Container(
                                margin: EdgeInsets.all(8.0),
                                width: 64.0,
                                height: 64.0,
                                child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Color(0XFFFFBD73)),
                                ),
                              )
                            else if (state == AudioPlaybackState.playing)
                              Container(
                                height: 90,
                                width: 90,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                    child: IconButton(
                                  icon: Icon(Icons.pause),
                                  iconSize: 64.0,
                                  color: Color(0XFFFFBD73),
                                  onPressed: _player.pause,
                                )),
                              )
                            else
                              Container(
                                height: 90,
                                width: 90,
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: IconButton(
                                    icon: Icon(Icons.play_arrow),
                                    color: Color(0XFFFFBD73),
                                    disabledColor: Color(0xFF9F7C55),
                                    iconSize: 64.0,
                                    onPressed: _player.play,
                                  ),
                                ),
                              ),
                            Container(
                              height: 90,
                              width: 90,
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: IconButton(
                                  icon: Icon(Icons.stop),
                                  color: Color(0XFFFFBD73),
                                  disabledColor: Color(0xFF9F7C55),
                                  iconSize: 64.0,
                                  onPressed:
                                      state == AudioPlaybackState.stopped ||
                                              state == AudioPlaybackState.none
                                          ? null
                                          : _player.stop,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 1),
                            blurRadius: 10,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: "\n",
                                style: Theme.of(context).textTheme.button),
                            TextSpan(
                                text: "Siguenos en:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontSize: 19))
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton.icon(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 25.0,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  textColor: Colors.white,
                  color: Color(0XFF2B5999),
                  icon: Icon(
                    FontAwesomeIcons.facebookF,
                    size: 28.0,
                  ),
                  label: Text(
                    "Facebook",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {},
                ),
                const SizedBox(width: 10.0),
                RaisedButton.icon(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 25.0,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  color: Color(0XFFE4405F),
                  textColor: Colors.white,
                  icon: Icon(
                    FontAwesomeIcons.instagram,
                    size: 28.0,
                  ),
                  label: Text(
                    "Instagram",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton.icon(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 25.0,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  color: Color(0XFFCD201F),
                  textColor: Colors.white,
                  icon: Icon(
                    FontAwesomeIcons.youtube,
                    size: 28.0,
                  ),
                  label: Text(
                    "  Youtube ",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {},
                ),
                const SizedBox(width: 10.0),
                RaisedButton.icon(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 25.0,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  color: Color(0XFF1DA1F2),
                  textColor: Colors.white,
                  icon: Icon(
                    FontAwesomeIcons.twitter,
                    size: 28.0,
                  ),
                  label: Text(
                    "Twitter     ",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        );
      default:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("This is the basket page DEFAULT"),
            RaisedButton(
              child: Text(
                "Start new page DEFAULT",
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).primaryColor,
              onPressed: () {},
            )
          ],
        );
    }
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

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = 20;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - 50;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
