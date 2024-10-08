import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Halloween Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Halloween Game Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _isFound = false;
  Random _random = Random();

  // Variables for audio
  final AudioPlayer _audioPlayer = AudioPlayer();
  late double _pumpkinTop, _pumpkinLeft;
  late double _ghostTop, _ghostLeft;
  late double _batTop, _batLeft;

  @override
  void initState() {
    super.initState();
    _playBackgroundMusic();

    // Initial random positions for items
    _pumpkinTop = _randomPosition(300);
    _pumpkinLeft = _randomPosition(300);
    _ghostTop = _randomPosition(300);
    _ghostLeft = _randomPosition(300);
    _batTop = _randomPosition(300);
    _batLeft = _randomPosition(300);

    // Start the movement of objects by updating their positions every 2 seconds
    Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _pumpkinTop = _randomPosition(MediaQuery.of(context).size.height - 100);
        _pumpkinLeft = _randomPosition(MediaQuery.of(context).size.width - 100);
        _ghostTop = _randomPosition(MediaQuery.of(context).size.height - 100);
        _ghostLeft = _randomPosition(MediaQuery.of(context).size.width - 100);
        _batTop = _randomPosition(MediaQuery.of(context).size.height - 100);
        _batLeft = _randomPosition(MediaQuery.of(context).size.width - 100);
      });
    });
  }

  // Generate random positions for floating objects
  double _randomPosition(double max) => _random.nextDouble() * max;

  // Play background music
  void _playBackgroundMusic() async {
    await _audioPlayer.setSource(AssetSource('assets/sound/spooky_background.mp3'));
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    _audioPlayer.play(AssetSource('assets/sound/spooky_background.mp3'));
  }

  // Function to display winning message
  void _showWinMessage() {
    setState(() {
      _isFound = true;
    });
    _audioPlayer.play(AssetSource('assets/sound/success.mp3'));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('You Found It!'),
        content: const Text('Happy Halloween! 🎃'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _isFound = false;
              });
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  // Method to increase the counter when traps are clicked
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    _audioPlayer.play(AssetSource('assets/sound/jump_scare.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.webp',
              fit: BoxFit.cover,
            ),
          ),

          // Floating pumpkin (correct item)
          _buildMovingObject('assets/images/pumpkin.webp', _showWinMessage, _pumpkinTop, _pumpkinLeft),

          // Floating ghost (trap)
          _buildMovingObject('assets/images/ghost.webp', _incrementCounter, _ghostTop, _ghostLeft),

          // Floating bat (trap)
          _buildMovingObject('assets/images/bat1.png', _incrementCounter, _batTop, _batLeft),

          // Centered counter message
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'You have triggered the traps this many times:',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  // Build the moving Halloween-themed objects (Pumpkin, Ghost, Bat)
  Widget _buildMovingObject(String imagePath, Function onTapCallback, double top, double left) {
    return AnimatedPositioned(
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      top: top,
      left: left,
      child: GestureDetector(
        onTap: () => onTapCallback(),
        child: Image.asset(
          imagePath,
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}
