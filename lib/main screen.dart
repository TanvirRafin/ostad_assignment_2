import 'dart:async';
import 'package:flutter/material.dart';
import 'model/song.dart';


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Song> playlist = [
    Song(
      title: 'Dreams',
      artist: 'Artist A',
      url: 'url1',
      durationSeconds: 180,
    ),
    Song(
      title: 'Sky High',
      artist: 'Artist B',
      url: 'url2',
      durationSeconds: 210,
    ),
    Song(
      title: 'Night Walk',
      artist: 'Artist C',
      url: 'url3',
      durationSeconds: 150,
    ),
  ];

  int currentIndex = 0;
  int currentSeconds = 0;
  bool isPlaying = false;
  Timer? timer;

  Song get currentSong => playlist[currentIndex];

  void playPause() {
    if (isPlaying) {
      timer?.cancel();
    } else {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (currentSeconds < currentSong.durationSeconds) {
          setState(() {
            currentSeconds++;
          });
        } else {
          nextSong();
        }
      });
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void nextSong() {
    timer?.cancel();
    setState(() {
      currentIndex = (currentIndex + 1) % playlist.length;
      currentSeconds = 0;
      isPlaying = false;
    });
  }

  void previousSong() {
    timer?.cancel();
    setState(() {
      currentIndex =
          (currentIndex - 1 + playlist.length) % playlist.length;
      currentSeconds = 0;
      isPlaying = false;
    });
  }

  String formatTime(int seconds) {
    final min = seconds ~/ 60;
    final sec = seconds % 60;
    return '$min:${sec.toString().padLeft(2, '0')}';
  }

  void playSelectedSong(int index) {
    timer?.cancel();
    setState(() {
      currentIndex = index;
      currentSeconds = 0;
      isPlaying = false;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Music Player'),
      ),
      body: Column(
        children: [
          /// 🔝 Top Player Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.deepPurple.shade50,
            child: Column(
              children: [
                Text(
                  currentSong.title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(currentSong.artist),
                Slider(
                  value: currentSeconds.toDouble(),
                  max: currentSong.durationSeconds.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      currentSeconds = value.toInt();
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatTime(currentSeconds)),
                    Text(formatTime(currentSong.durationSeconds)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.skip_previous),
                      iconSize: 36,
                      onPressed: previousSong,
                    ),
                    IconButton(
                      icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow),
                      iconSize: 40,
                      onPressed: playPause,
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next),
                      iconSize: 36,
                      onPressed: nextSong,
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// 🎵 Song List
          Expanded(
            child: ListView.builder(
              itemCount: playlist.length,
              itemBuilder: (context, index) {
                final song = playlist[index];
                return ListTile(
                  leading: Text('${index + 1}'),
                  title: Text(song.title),
                  subtitle: Text(song.artist),
                  onTap: () => playSelectedSong(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
