// ignore_for_file: camel_case_types, unnecessary_brace_in_string_interps, unused_field, prefer_const_constructors, sized_box_for_whitespace, avoid_print, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:io';

import 'package:audio_wave/audio_wave.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:jiffy/jiffy.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Generic/appConst.dart';

// class voiceRecorder extends StatefulWidget {
//   const voiceRecorder({super.key});

//   @override
//   State<voiceRecorder> createState() => _voiceRecorderState();
// }

// class _voiceRecorderState extends State<voiceRecorder> {
//   //final RecorderController recorderController = new RecorderController();
//   @override
//   void initState() {
//     initRecorder();
//     super.initState();
//   }

//   final recorder = FlutterSoundRecorder();
//   dynamic recordedAudio;
//   FlutterSoundPlayer? _audioPlayer;
//   FlutterSoundRecorder? _recordingSession;

//   Future initRecorder() async {
//     // final status = await Permission.microphone.request();
//     // if (status != PermissionStatus.granted) {
//     //   throw 'Permission not granted';
//     // }
//     await recorder.openRecorder();
//     recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
//   }

//   Future startRecord() async {
//     await recorder.startRecorder(
//         toFile: 'Audio_' + Jiffy().format('yyyyMMddHHmmss'));
//   }

//   Future stopRecorder() async {
//     final filePath = await recorder.stopRecorder();
//     final file = File(filePath!);
//     print('Recorded file path: $filePath');
//     setState(() {
//       recordedAudio = filePath;
//       setRecordedAudioPath(recordedAudio);
//       print('Recorded Files ${recordedAudio}.wav');
//       Navigator.pop(context);
//     });
//   }

//   Future pauseRecorder() async {
//     await recorder.pauseRecorder();
//   }

//   Future resumeRecorder() async {
//     await recorder.resumeRecorder();
//   }

//   Future<void> setRecordedAudioPath(audiopath) async {
//     final SharedPreferences pref = await SharedPreferences.getInstance();
//     pref.setString('audiopath', '${audiopath}');
//     print('save audio path is ${audiopath}');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           centerTitle: false,
//           backgroundColor: AppConst.appColorPrimary,
//           bottom: PreferredSize(
//             preferredSize: Size.fromHeight(35),
//             child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     width: 5,
//                   ),
//                   BackButton(
//                     color: Colors.white,
//                     onPressed: (() {
//                       Navigator.of(context).pop();
//                     }),
//                   ),
//                   SizedBox(
//                     width: 5,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 10),
//                     child: Text(
//                       'Support Ticket',
//                       style: TextStyle(color: Colors.white, fontSize: 18),
//                     ),
//                   )
//                 ]),
//           ),
//           title: Text(''),
//           automaticallyImplyLeading: false,
//         ),
//         // backgroundColor: Colors.teal.shade700,
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               StreamBuilder<RecordingDisposition>(
//                 builder: (context, snapshot) {
//                   final duration = snapshot.hasData
//                       ? snapshot.data!.duration
//                       : Duration.zero;

//                   String twoDigits(int n) => n.toString().padLeft(2, '0');

//                   final twoDigitMinutes =
//                       twoDigits(duration.inMinutes.remainder(60));
//                   final twoDigitSeconds =
//                       twoDigits(duration.inSeconds.remainder(60));

//                   return Text(
//                     '$twoDigitMinutes:$twoDigitSeconds',
//                     style: const TextStyle(
//                       color: Colors.black,
//                       fontSize: 30,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   );
//                 },
//                 stream: recorder.onProgress,
//               ),
//               const SizedBox(height: 20),
//               // InkWell(
//               //     onTap: () async {
//               //       if (recorder.isRecording) {
//               //         await stopRecorder();
//               //         setState(() {});
//               //       } else {
//               //         await startRecord();
//               //         setState(() {});
//               //       }
//               //     },
//               //     child: Icon(
//               //       recorder.isRecording ? Icons.stop : Icons.mic,
//               //     )
//               //     ),
//               Container(
//                 child: ElevatedButton(
//                   style: ButtonStyle(
//                       backgroundColor:
//                           MaterialStateProperty.all(AppConst.appColorPrimary),
//                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                         RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(0)),
//                       )),
//                   onPressed: () async {
//                     if (recorder.isRecording) {
//                       await stopRecorder();
//                       setState(() {});
//                     } else {
//                       await startRecord();
//                       setState(() {});
//                     }
//                   },
//                   child: Icon(
//                     recorder.isRecording ? Icons.stop : Icons.mic,
//                     size: 100,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Container(
//                     width: 100,
//                     child: InkWell(
//                         onTap: () async {
//                           if (recorder.isRecording) {
//                             await pauseRecorder();
//                             setState(() {});
//                           } else {
//                             await resumeRecorder();
//                             setState(() {});
//                           }

//                           // OpenFile.open(recordedAudio);
//                           // playFunc();
//                         },
//                         child: Icon(
//                           recorder.isRecording
//                               ? FeatherIcons.pauseCircle
//                               : Icons.play_circle,
//                           size: 50,
//                           color: AppConst.appColorPrimary,
//                         ))),
//               ),
//               recorder.isRecording
// ? AudioWave(
//     animation: true,
//     height: 32,
//     width: 300,
//     spacing: 2.5,
//     // alignment: 'top',
//     animationLoop: 2,
//     beatRate: Duration(milliseconds: 500),
//     bars: [
//       AudioWaveBar(
//           color: Colors.lightBlueAccent, heightFactor: 1),
//       AudioWaveBar(color: Colors.blue, heightFactor: 0.5),
//       AudioWaveBar(color: Colors.black, heightFactor: 1),
//       AudioWaveBar(color: Colors.green, heightFactor: 0.7),
//       AudioWaveBar(color: Colors.orange, heightFactor: 0.9),
//       AudioWaveBar(
//           color: Colors.lightBlueAccent, heightFactor: 1),
//       AudioWaveBar(color: Colors.blue, heightFactor: 0.6),
//       AudioWaveBar(color: Colors.black, heightFactor: 1),
//       AudioWaveBar(heightFactor: 0.9),
//       AudioWaveBar(color: Colors.orange, heightFactor: .06),
//       AudioWaveBar(
//           color: Colors.lightBlueAccent, heightFactor: 1),
//       AudioWaveBar(color: Colors.blue, heightFactor: 0.6),
//       AudioWaveBar(color: Colors.black, heightFactor: 1),
//       AudioWaveBar(color: Colors.blue, heightFactor: 0.8),
//       AudioWaveBar(color: Colors.orange, heightFactor: 0.8),
//       AudioWaveBar(
//           color: Colors.lightBlueAccent, heightFactor: 1),
//       AudioWaveBar(color: Colors.blue, heightFactor: 0.6),
//       AudioWaveBar(color: Colors.black, heightFactor: 1),
//       AudioWaveBar(heightFactor: 0.4),
//       AudioWaveBar(color: Colors.red, heightFactor: 0.5),
//       AudioWaveBar(
//           color: Colors.blueAccent, heightFactor: 0.9),
//       AudioWaveBar(color: Colors.grey, heightFactor: 0.7),
//       AudioWaveBar(
//           color: Colors.deepOrange, heightFactor: 0.4),
//       AudioWaveBar(color: Colors.blue, heightFactor: 1),
//       AudioWaveBar(color: Colors.orange, heightFactor: 0.8),
//       AudioWaveBar(color: Colors.black, heightFactor: 0.7),
//       AudioWaveBar(
//           color: Colors.lightBlueAccent, heightFactor: 0.2),
//       AudioWaveBar(color: Colors.grey, heightFactor: 0.7),
//       AudioWaveBar(color: Colors.red, heightFactor: 0.5),
//       AudioWaveBar(color: Colors.blue, heightFactor: 1),
//       AudioWaveBar(color: Colors.black, heightFactor: 0.6),
//     ],
//   )
//                   : Container()
//             ],
//           ),
//         ));
//   }
// }

class voiceRecorder extends StatefulWidget {
  Function(String path) onStop;
  voiceRecorder({super.key, required this.onStop});

  @override
  State<voiceRecorder> createState() => _voiceRecorderState();
}

class _voiceRecorderState extends State<voiceRecorder> {
  int _recordDuration = 0;
  Timer? _timer;
  final _audioRecorder = Record();
  StreamSubscription<RecordState>? _recordSub;
  RecordState _recordState = RecordState.stop;
  StreamSubscription<Amplitude>? _amplitudeSub;
  Amplitude? _amplitude;

  @override
  void initState() {
    _recordSub = _audioRecorder.onStateChanged().listen((recordState) {
      setState(() => _recordState = recordState);
    });

    _amplitudeSub = _audioRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 300))
        .listen((amp) => setState(() => _amplitude = amp));

    super.initState();
  }

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        // We don't do anything with this but printing
        final isSupported = await _audioRecorder.isEncoderSupported(
          AudioEncoder.aacLc,
        );
        if (kDebugMode) {
          print('${AudioEncoder.aacLc.name} supported: $isSupported');
        }

        // final devs = await _audioRecorder.listInputDevices();
        // final isRecording = await _audioRecorder.isRecording();

        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;

        await _audioRecorder.start(
            path: tempPath +
                '/' +
                'RecAud_' +
                Jiffy().format('yyyyMMdd_HHmmss') +
                '.wav');
        _recordDuration = 0;

        _startTimer();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _stop() async {
    _timer?.cancel();
    _recordDuration = 0;

    final path = await _audioRecorder.stop();

    if (path != null) {
      widget.onStop(path);
    }
  }

  Future<void> _pause() async {
    _timer?.cancel();
    await _audioRecorder.pause();
  }

  Future<void> _resume() async {
    _startTimer();
    await _audioRecorder.resume();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildRecordStopControl(),
              const SizedBox(width: 20),
              _buildPauseResumeControl(),
              const SizedBox(width: 20),
              _buildText(),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          // _recordState == RecordState.record
          //     ? AudioWave(
          //         animation: true,
          //         height: 50,
          //         width: 300,
          //         spacing: 2.5,
          //         // alignment: 'top',
          //         animationLoop: 4,
          //         beatRate: Duration(milliseconds: 500),
          //         bars: [
          //           AudioWaveBar(
          //             color: Colors.lightBlueAccent,
          //             heightFactor: 1,
          //           ),
          //           AudioWaveBar(color: Colors.blue, heightFactor: 0.5),
          //           AudioWaveBar(color: Colors.black, heightFactor: 1),
          //           AudioWaveBar(color: Colors.green, heightFactor: 0.7),
          //           AudioWaveBar(color: Colors.orange, heightFactor: 0.9),
          //           AudioWaveBar(
          //               color: Colors.lightBlueAccent, heightFactor: 1),
          //           AudioWaveBar(color: Colors.blue, heightFactor: 0.6),
          //           AudioWaveBar(color: Colors.black, heightFactor: 1),
          //           AudioWaveBar(heightFactor: 0.9),
          //           AudioWaveBar(color: Colors.orange, heightFactor: .06),
          //           AudioWaveBar(
          //               color: Colors.lightBlueAccent, heightFactor: 1),
          //           AudioWaveBar(color: Colors.blue, heightFactor: 0.6),
          //           AudioWaveBar(color: Colors.black, heightFactor: 1),
          //           AudioWaveBar(color: Colors.blue, heightFactor: 0.8),
          //           AudioWaveBar(color: Colors.orange, heightFactor: 0.8),
          //           AudioWaveBar(
          //               color: Colors.lightBlueAccent, heightFactor: 1),
          //           AudioWaveBar(color: Colors.blue, heightFactor: 0.6),
          //           AudioWaveBar(color: Colors.black, heightFactor: 1),
          //           AudioWaveBar(heightFactor: 0.4),
          //           AudioWaveBar(color: Colors.red, heightFactor: 0.5),
          //           AudioWaveBar(color: Colors.blueAccent, heightFactor: 0.9),
          //           AudioWaveBar(color: Colors.grey, heightFactor: 0.7),
          //           AudioWaveBar(color: Colors.deepOrange, heightFactor: 0.4),
          //           AudioWaveBar(color: Colors.blue, heightFactor: 1),
          //           AudioWaveBar(color: Colors.orange, heightFactor: 0.8),
          //           AudioWaveBar(color: Colors.black, heightFactor: 0.7),
          //           AudioWaveBar(
          //               color: Colors.lightBlueAccent, heightFactor: 0.2),
          //           AudioWaveBar(color: Colors.grey, heightFactor: 0.7),
          //           AudioWaveBar(color: Colors.red, heightFactor: 0.5),
          //           AudioWaveBar(color: Colors.blue, heightFactor: 1),
          //           AudioWaveBar(color: Colors.black, heightFactor: 0.6),
          //           AudioWaveBar(
          //               color: Colors.lightBlueAccent, heightFactor: 1),
          //           AudioWaveBar(color: Colors.grey, heightFactor: 0.7),
          //           AudioWaveBar(color: Colors.orange, heightFactor: 0.8),
          //           AudioWaveBar(color: Colors.green, heightFactor: 0.7),
          //         ],
          //       )
          //     : Container()

          // if (_amplitude != null) ...[
          //   const SizedBox(height: 40),
          //   Text('Current: ${_amplitude?.current ?? 0.0}'),
          //   Text('Max: ${_amplitude?.max ?? 0.0}'),
          // ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recordSub?.cancel();
    _amplitudeSub?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  Widget _buildRecordStopControl() {
    late Icon icon;
    late Color color;

    if (_recordState != RecordState.stop) {
      icon = const Icon(Icons.stop, color: AppConst.appColorPrimary, size: 35);
      color = AppConst.appColorPrimary.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.mic, color: theme.primaryColor, size: 35);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: 56, height: 56, child: icon),
          onTap: () {
            (_recordState != RecordState.stop) ? _stop() : _start();
          },
        ),
      ),
    );
  }

  Widget _buildPauseResumeControl() {
    if (_recordState == RecordState.stop) {
      return const SizedBox.shrink();
    }

    late Icon icon;
    late Color color;

    if (_recordState == RecordState.record) {
      icon = const Icon(Icons.pause, color: AppConst.appColorPrimary, size: 30);
      color = AppConst.appColorPrimary.withOpacity(0);
    } else {
      final theme = Theme.of(context);
      icon = const Icon(Icons.play_arrow,
          color: AppConst.appColorPrimary, size: 30);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: 56, height: 56, child: icon),
          onTap: () {
            (_recordState == RecordState.pause) ? _resume() : _pause();
          },
        ),
      ),
    );
  }

  Widget _buildText() {
    if (_recordState != RecordState.stop) {
      return _buildTimer();
    }

    return const Text("Tap to record");
  }

  Widget _buildTimer() {
    final String minutes = _formatNumber(_recordDuration ~/ 60);
    final String seconds = _formatNumber(_recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: const TextStyle(color: Colors.black),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0$numberStr';
    }

    return numberStr;
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });
  }
}

class Voice extends StatefulWidget {
  const Voice({Key? key}) : super(key: key);

  @override
  State<Voice> createState() => _VoiceState();
}

class _VoiceState extends State<Voice> {
  bool showPlayer = false;
  String? audioPath;

  @override
  void initState() {
    showPlayer = false;
    super.initState();
  }

  Future<void> setRecordedAudioPath(audiopath) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('audiopath', '${audiopath}');
    print('save audio path is ${audiopath}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: AppConst.appColorPrimary,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(35),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 5,
                ),
                BackButton(
                  color: Colors.white,
                  onPressed: (() {
                    Navigator.of(context).pop();
                  }),
                ),
                SizedBox(
                  width: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Support Ticket',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                )
              ]),
        ),
        title: Text(''),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: voiceRecorder(
          onStop: (path) {
            if (kDebugMode) print('Recorded file path: $path');
            setState(() {
              audioPath = path;
              showPlayer = true;
              setRecordedAudioPath(audioPath);
              Navigator.of(context).pop();
            });
          },
        ),
      ),
    );
  }
}
