import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'State Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: CounterPage(
          title: 'Counter',
        ),
      ),
    );
  }
}

class CounterInheritedModel extends InheritedModel<String> {
  CounterInheritedModel({
    Key? key,
    required Widget child,
    required this.data,
  }) : super(key: key, child: child);

  final _CounterPageState data;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  @override
  bool updateShouldNotifyDependent(
    covariant InheritedModel oldWidget,
    Set dependencies,
  ) {
    return true;
  }

  static CounterInheritedModel? of(BuildContext context, String aspect) {
    return InheritedModel.inheritFrom<CounterInheritedModel>(
      context,
      aspect: aspect,
    );
  }
}

class DummyContainer extends StatelessWidget {
  const DummyContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class FakeContainer extends StatelessWidget {
  const FakeContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Counter();
  }
}

class CounterPage extends StatefulWidget {
  CounterPage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _CounterPageState createState() => _CounterPageState();

  static _CounterPageState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<CounterInheritedModel>()!
        .data;
  }
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: CounterInheritedModel(
          child: Container(),
          data: this,
        ),
      ),
    );
  }
}

class Counter extends StatefulWidget {
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  var incrementButtonClicked = 0;
  var decrementButtonClicked = 0;

  var counter;

  late CounterInheritedModel inheritedModel;

  @override
  Widget build(BuildContext context) {
    inheritedModel = CounterInheritedModel.of(context, "")!;

    counter = inheritedModel.data._counter;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Counter: ',
                style: Theme.of(context).textTheme.headline4,
              ),
              Text(
                '$counter',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Text>[
              Text(
                '\'Increment Button\' clicked $incrementButtonClicked times',
              ),
              Text(
                '\'Decrement Button\' clicked $decrementButtonClicked times',
              ),
            ],
          ),
          TextButton(
            child: Text(
              'Increment counter',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onPressed: () {
              inheritedModel.data._incrementCounter();

              setState(() {
                incrementButtonClicked++;
              });
            },
          ),
          TextButton(
            child: Text(
              'Decrement counter',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onPressed: () {
              inheritedModel.data._decrementCounter();

              setState(() {
                incrementButtonClicked++;
              });
            },
          ),
        ],
      ),
    );
  }
}
