import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepcompare/model.dart';
import 'package:stepcompare/widgets/garmin_auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider<AppModel>.value(
      value: AppModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
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
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                const Text('hellos'),
                if (!model.hasAccess)
                  TextButton.icon(
                    onPressed: () => model.giveAccess(),
                    icon: const Icon(Icons.lock),
                    label: const Text('Give access'),
                  ),
                if (model.hasAccess)
                  TextButton.icon(
                    onPressed: () => model.getSteps(),
                    icon: const Icon(Icons.run_circle_outlined),
                    label: const Text('Get steps'),
                  ),
                Text('Steps: ${model.phoneSteps.length}'),
                GarminAuth(
                  callback: (args) {
                    print(args);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
