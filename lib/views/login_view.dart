
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kartoraeat/bloc/app_bloc.dart';
import 'package:kartoraeat/bloc/app_event.dart';
import 'package:kartoraeat/extensions/if_debugging.dart';

class LoginView extends HookWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController(
      text: ''.ifDebugging,
    );

    final passwordController = useTextEditingController(
      text: ''.ifDebugging,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Log in'
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Enter your email here..'
              ),
              keyboardType: TextInputType.emailAddress,
              keyboardAppearance: Brightness.dark,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                  hintText: 'Enter your password here'
              ),
              keyboardType: TextInputType.emailAddress,
              keyboardAppearance: Brightness.dark,
              obscureText: true,
              //obscuringCharacter: '',
            ),
            TextButton(
                onPressed: (){
                  final email = emailController.text;
                  final password = passwordController.text;
                  context.read<AppBloc>().add(
                      AppEventLogIn(
                        email: email,
                        password: password,
                      )
                  );
                },
                child: const Text('Log in')
            ),
            TextButton(
                onPressed: (){
                  final email = emailController.text;
                  final password = passwordController.text;
                  context.read<AppBloc>().add(
                      const AppEventGoToRegistration(

                      ),
                  );
                },
                child: const Text('Not Registerd yet? register here')
            ),
          ],
        ),
      ),
    );
  }
}

