import 'package:flutter/material.dart';

import 'package:password_strength_checker/password_strength_checker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool isVisiblePass = false;
  ValueNotifier<PasswordStrength?> passNotifier = ValueNotifier<PasswordStrength?>(null);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Register 🔐', style: textTheme.titleLarge),
              const SizedBox(height: 15),
              Text(PasswordStrength.instructions),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: !isVisiblePass,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon( 
                      isVisiblePass 
                        ? Icons.visibility 
                        : Icons.visibility_off,
                      size: 20
                    ),
                    onPressed: () {
                      setState(() {
                        isVisiblePass = !isVisiblePass;
                      });
                    },
                  )
                ),
                onChanged: (value) {
                  passNotifier.value = PasswordStrength.calculate(text: value);
                },
              ),
              const SizedBox(height: 20),
              PasswordStrengthChecker(
                strength: passNotifier,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.maxFinite,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    var config = const PasswordGeneratorConfiguration(
                      length: 32,
                      minUppercase: 8,
                      minSpecial: 8,
                      minDigits: 4,
                      minLowercase: 2,
                    );

                    final passwordGenerator = PasswordGenerator.fromConfig(
                      configuration: config,
                    );

                    final password = passwordGenerator.generate();
                    setState(() {
                      _passwordController.text = password;
                      passNotifier.value = PasswordStrength.calculate(text: password);
                    });
                  },
                  child: const Text('Generate Password', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.maxFinite,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    if ( passNotifier.value == PasswordStrength.secure ) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Error, insecure password')
                      ),
                    );
                  },
                  child: const Text('Submit', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}