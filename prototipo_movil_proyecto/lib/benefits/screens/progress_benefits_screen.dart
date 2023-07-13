import 'package:flutter/material.dart';
import 'package:prototipo_movil_proyecto/benefits/models/question_model.dart';
import 'package:prototipo_movil_proyecto/benefits/models/user_product_model.dart';
import 'package:prototipo_movil_proyecto/benefits/requests/benefits_requests.dart';
import 'package:prototipo_movil_proyecto/benefits/screens/benefits_screen.dart';
import 'package:prototipo_movil_proyecto/products/models/product_model.dart';
import 'package:prototipo_movil_proyecto/products/screens/products_screen.dart';
import 'package:prototipo_movil_proyecto/trips/screens/trips_screen.dart';
import 'package:prototipo_movil_proyecto/users/screens/users_screen.dart';

class ProgressBenefitScreen extends StatefulWidget {
  final int userId;
  final String csrfToken;
  final UserProduct? userProduct;
  const ProgressBenefitScreen(
      {super.key,
      required this.userId,
      required this.csrfToken,
      this.userProduct});

  @override
  State<ProgressBenefitScreen> createState() => _ProgressBenefitScreenState();
}

class _ProgressBenefitScreenState extends State<ProgressBenefitScreen> {
  int _selectedIndex = 0;
  int points = 0;
  bool allQuestionsAnswered = false;
  Product? product;
  List<Question> questions = [];
  List<bool> answerSelected = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = 3;
    getProduct(widget.userProduct!.productCode).then((value) {
      setState(() {
        product = value;
        if (product != null) {
          getQuestions(product!.country).then((value) {
            setState(() {
              questions = value;
              answerSelected = List.generate(questions.length, (_) => false);
              for (var element in questions) {
                element.description = element.description.substring(1);
              }
            });
          });
        }
      });
    });
  }

  void selectAnswer(bool isCorrect, int index) {
    if (isCorrect) {
      setState(() {
        points += 50;
      });
    }
    setState(() {
      answerSelected[index] = true;
    });
    bool allAnswered = answerSelected.every((answered) => answered);
    setState(() {
      allQuestionsAnswered = allAnswered;
    });
  }

  void showResultDialog() {
    if (allQuestionsAnswered) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Resultado'),
            content: Text('¡Has obtenido $points puntos!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  sendPoints(widget.userId, points, widget.csrfToken);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => BenefitScreen(
                        userId: widget.userId, csrfToken: widget.csrfToken),
                  ));
                },
                child: const Text('Cerrar'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Alerta'),
            content: const Text('¡Existen preguntas sin responder!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cerrar'),
              ),
            ],
          );
        },
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserScreen(
            userId: widget.userId,
            csrfToken: widget.csrfToken,
          ),
        ),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TripScreen(
            userId: widget.userId,
            csrfToken: widget.csrfToken,
          ),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductScreen(
            userId: widget.userId,
            csrfToken: widget.csrfToken,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset('assets/images/logo_text.png'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('CONOCIENDO EL MUNDO', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  final isAnswerSelected = answerSelected[index];
                  return Column(
                    children: [
                      Text(
                        question.description,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          for (int i = 0; i < 3; i++)
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.green,
                                  width: 3.0,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: ListTile(
                                title: Text(
                                  i == 0 ? question.answer : 'OPCION $i',
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                onTap: () {
                                  if (!isAnswerSelected) {
                                    if (i == 0) {
                                      selectAnswer(true, index);
                                    } else {
                                      selectAnswer(false, index);
                                    }
                                  }
                                },
                                tileColor: isAnswerSelected
                                    ? Colors.grey.withOpacity(0.5)
                                    : null,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 25),
                    ],
                  );
                },
              ),
              ElevatedButton(
                onPressed: allQuestionsAnswered ? showResultDialog : null,
                child: const Text('Responder'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.blue,
          primaryColor: Colors.white,
          textTheme: Theme.of(context).textTheme.copyWith(
                bodySmall: const TextStyle(color: Colors.white),
              ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Usuario',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.place),
              label: 'Viajes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.airplane_ticket),
              label: 'Productos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Beneficios',
            ),
          ],
        ),
      ),
    );
  }
}
