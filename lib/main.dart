import 'package:expense_controll3_app/core/widgets/custom_app_bar.dart';
import 'package:expense_controll3_app/core/widgets/custom_neumorphic_button.dart';
import 'package:expense_controll3_app/core/widgets/custom_snackbar.dart';
import 'package:expense_controll3_app/core/widgets/expense_card.dart';
import 'package:expense_controll3_app/core/widgets/neumorphic_text_form_field.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EXPENSE CONTROLL',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'APP BAR CUSTOMIZADO'),
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

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: .center,
            children: [
              const Text('You have pushed the button this many times:'),
              // const SizedBox(height: 50),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomNeumorphicButton(
                // textColor: Colors.amber,
                text: 'botão teste',
                icon: Icons.add,
                onPressed: () {
                  _incrementCounter();
                  CustomSnackBar.showSuccess(context, 'Operation successful!');
                },
              ),
              const SizedBox(
                height: 20,
              ),
              NeumorphicTextFormField(
                hintText: 'Digite algo',
              ),
              const SizedBox(
                height: 20,
              ),
              ExpenseCard(
                id: '1',
                amount: 100.0,
                category: 'Food',
                description: 'Lunch at restaurant',
                date: DateTime.now(),
                isIncome: false,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
