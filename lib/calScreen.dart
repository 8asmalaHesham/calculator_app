import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> symbols = [
    'C','Del','%','/',
    '7','8','9','*',
    '4','5','6','-',
    '1','2','3','+',
    '.','0','()', '=',
  ];

  String input = '';
  String output = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 175, 96, 215),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(6),
              width: double.infinity,
              child: Text(
                input,
                textAlign: TextAlign.right,
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(6),
              width: double.infinity,
              child: Text(
                output,
                textAlign: TextAlign.right,
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.normal,
                  color: Color.fromARGB(255, 111, 5, 140),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: GridView.builder(
              itemCount: symbols.length,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: myBackgroundColor(symbols[index]),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: myBoxShadow(symbols[index]),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (symbols[index] == 'C') {
                            input = '';
                            output = '';
                          } else if (symbols[index] == 'Del') {
                            if (input.isNotEmpty) {
                              input = input.substring(0, input.length - 1);
                            }
                          } else if (symbols[index] == '()') {
                            if (_shouldCloseBracket()) {
                              input += ')';
                            } else {
                              input += '(';
                            }
                          } else if (symbols[index] == '=') {
                            if (output.isNotEmpty) {
                              input = output;
                              output = '';
                            }
                          } else {
                            input += symbols[index];
                            _calculate();
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(30),
                      splashColor: mySplashColor(symbols[index]),
                      highlightColor: myHighlightColor(symbols[index]),
                      child: Center(
                        child: Text(
                          symbols[index],
                          style: TextStyle(
                            color: myTextColor(symbols[index]),
                            fontWeight: FontWeight.w600,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _calculate() {
    try {
      if (input.isNotEmpty && !_endsWithOperator()) {
        String fixedInput = _autoCloseBrackets(input);
        Parser p = Parser();
        Expression exp = p.parse(fixedInput);
        ContextModel cm = ContextModel();
        double result = exp.evaluate(EvaluationType.REAL, cm);
        output =
            (result % 1 == 0) ? result.toInt().toString() : result.toString();
      }
    } catch (e) {
      output = 'Error';
    }
  }

  bool _endsWithOperator() {
    return input.endsWith('+') ||
        input.endsWith('-') ||
        input.endsWith('*') ||
        input.endsWith('/') ||
        input.endsWith('%');
  }

  bool _shouldCloseBracket() {
    int openCount = '('.allMatches(input).length;
    int closeCount = ')'.allMatches(input).length;
    return openCount > closeCount;
  }

  String _autoCloseBrackets(String expression) {
    int openCount = '('.allMatches(expression).length;
    int closeCount = ')'.allMatches(expression).length;
    while (closeCount < openCount) {
      expression += ')';
      closeCount++;
    }
    return expression;
  }

  Color myBackgroundColor(String x) {
    if (x == 'C' ||
        x == 'Del' ||
        x == '/' ||
        x == '*' ||
        x == '+' ||
        x == '-' ||
        x == '()'||
        x == '%' ||
        x == '=') {
      return const Color.fromARGB(255, 199, 132, 211);
    } else {
      return const Color.fromARGB(255, 234, 184, 252);
    }
  }

  Color myTextColor(String x) {
    if (x == '%' ||
        x == '/' ||
        x == '*' ||
        x == '+' ||
        x == 'C' ||
        x == 'Del' ||
        x == '()' ||
        x == '=' ||
        x == '-') {
      return Colors.white;
    } else {
      return Colors.black54;
    }
  }

  List<BoxShadow> myBoxShadow(String x) {
    if (x == 'C' ||
        x == 'Del' ||
        x == '/' ||
        x == '*' ||
        x == '+' ||
        x == '-' ||
        x == '()' ||
        x == '%' ||
        x == '=') {
      return [
        BoxShadow(
          color: Colors.purple.withOpacity(0.3),
          blurRadius: 5,
          spreadRadius: 1,
          offset: const Offset(0, 1),
        ),
      ];
    } else {
      return [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          blurRadius: 5,
          spreadRadius: 1,
          offset: const Offset(0, 1),
        ),
      ];
    }
  }

  Color mySplashColor(String x) {
    if (x == 'C' ||
        x == 'Del' ||
        x == '/' ||
        x == '*' ||
        x == '+' ||
        x == '-' ||
        x == '()' ||
        x == '%' ||
        x == '=') {
      return const Color.fromARGB(255, 139, 41, 156).withOpacity(0.3);
    } else {
      return const Color.fromARGB(255, 217, 149, 242).withOpacity(0.3);
    }
  }

  Color myHighlightColor(String x) {
    if (x == 'C' ||
        x == 'Del' ||
        x == '/' ||
        x == '*' ||
        x == '+' ||
        x == '-' ||
        x == '()' ||
        x == '%' ||
        x == '=') {
      return const Color.fromARGB(255, 139, 41, 156).withOpacity(0.1);
    } else {
      return const Color.fromARGB(255, 217, 149, 242).withOpacity(0.1);
    }
  }
}






