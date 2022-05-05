import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:stepcompare/garmin_client.dart';
import 'package:stepcompare/model.dart';

class GarminAuth extends StatelessWidget {
  final Function callback;
  const GarminAuth({
    Key? key,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => _displayAuthOverlay(context),
      icon: const Icon(Icons.login),
      label: const Text('Sign in with Garmin'),
    );
  }

  _displayAuthOverlay(BuildContext context) {
    // display GarminLogin as a popup
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign in with Garmin'),
        content: GarminLogin(callback: (data) {
          callback(data);
          Navigator.of(context).pop();
        }),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class GarminLogin extends HookWidget {
  final Function callback;
  const GarminLogin({
    Key? key,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppModel model = Provider.of<AppModel>(context);

    var username = useTextEditingController(text: '');
    var password = useTextEditingController(text: '');

    return SizedBox(
      width: 1200,
      height: 250,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: username,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: password,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
            ),
            const SizedBox(height: 8.0),
            TextButton.icon(
              onPressed: () async {
                GarminClient client =
                    GarminClient(username.text, password.text);
                await client.connect();
                // String today = DateTime.now().toIso8601String().substring(0, 10);
                List<GarminStep> data = await client.fetchSteps(
                  model.start,
                  model.end,
                );
                callback(data);
              },
              icon: const Icon(Icons.login),
              label: const Text('Sign in'),
            )
          ],
        ),
      ),
    );
  }
}
