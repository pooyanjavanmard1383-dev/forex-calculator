import 'package:flutter/material.dart';

void main() {
  runApp(const ForexApp());
}

class ForexApp extends StatelessWidget {
  const ForexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Forex Calculator',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.greenAccent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final balanceController = TextEditingController(text: '1000');
  final riskController = TextEditingController(text: '1');
  final stopController = TextEditingController(text: '10');

  double? lotSize;
  String errorMessage = '';

  void calculate() {
    final balance = double.tryParse(balanceController.text);
    final risk = double.tryParse(riskController.text);
    final stop = double.tryParse(stopController.text);

    if (balance == null || risk == null || stop == null ||
        balance <= 0 || risk <= 0 || stop <= 0) {
      setState(() {
        lotSize = null;
        errorMessage = 'Enter valid numbers greater than zero.';
      });
      return;
    }

    // Simplified example: assumes pip value is $10 per pip per 1.00 lot.
    final result = (balance * risk / 100) / (stop * 10);

    setState(() {
      lotSize = result;
      errorMessage = '';
    });
  }

  Widget inputField(String title, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 15)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  void dispose() {
    balanceController.dispose();
    riskController.dispose();
    stopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FOREX CALCULATOR'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            inputField('Account Balance (USD)', balanceController),
            inputField('Risk (%)', riskController),
            inputField('Stop Loss (Pips)', stopController),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: calculate,
                child: const Text('CALCULATE'),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'LOT SIZE',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, letterSpacing: 2),
            ),
            const SizedBox(height: 10),
            Text(
              lotSize == null ? '--' : lotSize!.toStringAsFixed(2),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 46,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent,
              ),
            ),
            if (errorMessage.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ],
            const SizedBox(height: 24),
            const Text(
              'Note: This basic example assumes a pip value of USD 10 '
              'per pip for 1.00 standard lot. Actual pip value varies by '
              'symbol, account currency, and market price.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
