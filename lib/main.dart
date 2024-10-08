import 'package:flutter/material.dart';
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

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  int _counter = 0;
  bool _isFound = false;
  late AnimationController _controller;
  Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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

  // Generate random positions for floating objects
  double _randomPosition(double max) => _random.nextDouble() * max;

  // Method to increase the counter
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
          // Halloween-themed objects floating
          _buildFloatingObject('🎃', _showWinMessage, _randomPosition(350), _randomPosition(500)),
          _buildFloatingObject('👻', _incrementCounter, _randomPosition(200), _randomPosition(300)),
          _buildFloatingObject('🦇', _incrementCounter, _randomPosition(100), _randomPosition(150)),

          // Centered counter message
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'You have triggered the traps this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  // Build floating animated objects (Pumpkin, Ghost, Bat)
  Widget _buildFloatingObject(String emoji, Function onTapCallback, double startTop, double startLeft) {
    return Positioned(
      top: startTop,
      left: startLeft,
      child: GestureDetector(
        onTap: () => onTapCallback(),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, sin(_controller.value * 2 * pi) * 20),
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 50),
              ),
            );
          },
        ),
      ),
    );
  }
}
