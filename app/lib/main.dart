import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepcompare/model.dart';
import 'package:stepcompare/widgets/garmin_auth.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  AppModel model = AppModel();
  await model.init();

  runApp(
    ChangeNotifierProvider<AppModel>.value(
      value: model,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppModel model = Provider.of<AppModel>(context);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Stepcompare',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
              fontSize: 20,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: model.uploading
                ? const CircularProgressIndicator()
                : const Home(),
          ),
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppModel model = Provider.of<AppModel>(context);

    return Column(
      children: [
        const Text(
          'Hello, this is the test version of Stepcompare. The button below asks for access and fetches your steps from Apple health or Google fit, and then you can sign in with Garmin to compare your steps. The result will be uploaded and not visible in the app.',
        ),
        const SizedBox(height: 8),
        const Text('Your userId is:'),
        Text('${model.userId}',
            style: const TextStyle(fontWeight: FontWeight.w700)),
        const Text(
            'If you want to remain anonymous keep this to yourself, otherwise this can be used to identify your data for the people running the experiment.'),
        const SizedBox(height: 16),
        _phoneSteps(context, model),
        const SizedBox(height: 16),
        _garminSteps(context, model),
      ],
    );
  }

  Widget _garminSteps(BuildContext context, AppModel model) {
    if (model.garminCompleted) {
      return const Text(
        'Garmin steps uploaded, thank you for helping us test!',
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Upload Steps from garmin:'),
        GarminAuth(
          callback: (args) {
            model.uploadGarmin(args);
          },
        ),
      ],
    );
  }

  Widget _phoneSteps(BuildContext context, AppModel model) {
    if (model.phoneCompleted) {
      return const Text(
        'Phone steps uploaded, thank you for helping us test!',
      );
    }
    return Column(
      children: [
        const Text('Upload Steps from phone and/or Apple watch:'),
        if (model.hasAccess)
          TextButton.icon(
            onPressed: () => model.getAndUploadSteps(),
            icon: const Icon(Icons.run_circle_outlined),
            label: const Text('Get and upload steps'),
          ),
        if (!model.hasAccess)
          TextButton.icon(
            onPressed: () => model.giveAccess(),
            icon: const Icon(Icons.lock),
            label: const Text('Give access'),
          )
      ],
    );
  }
}
