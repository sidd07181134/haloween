import 'package:flutter/material.dart';
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

  // Variables to store positions of objects
  late double _pumpkinTop, _pumpkinLeft;
  late double _ghostTop, _ghostLeft;
  late double _batTop, _batLeft;

  @override
  void initState() {
    super.initState();

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

  // Function to display winning message
  void _showWinMessage() {
    setState(() {
      _isFound = true;
    });
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
          // Floating pumpkin (correct item)
          _buildMovingObject('🎃', _showWinMessage, _pumpkinTop, _pumpkinLeft),

          // Floating ghost (trap)
          _buildMovingObject('👻', _incrementCounter, _ghostTop, _ghostLeft),

          // Floating bat (trap)
          _buildMovingObject('🦇', _incrementCounter, _batTop, _batLeft),

          // Centered counter message
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'You have triggered the traps this many times:',
                  style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: const Color.fromARGB(255, 0, 0, 0)),
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
  Widget _buildMovingObject(
      String emoji, Function onTapCallback, double top, double left) {
    return AnimatedPositioned(
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      top: top,
      left: left,
      child: GestureDetector(
        onTap: () => onTapCallback(),
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 50),
        ),
      ),
    );
  }
}
