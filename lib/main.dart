import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rick_and_morty_app/bloc_observable.dart';
import 'package:rick_and_morty_app/ui/pages/home_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final storage = await HydratedStorage.build(// Хранилище для кэширования
  //   storageDirectory: await getTemporaryDirectory(), // Храним состояние во временных папках
  // );
  // HydratedBlocOverrides.observer = CharacterBlocObservable();

  Bloc.observer = CharacterBlocObservable(); // Логгирование событий и ошибок bloc
  // runApp(const MyApp());

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Rick and Morty",
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.black,
          fontFamily: "Georgia",
          textTheme: const TextTheme(
              displayLarge: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              displayMedium: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
              displaySmall: TextStyle(
                  fontSize: 24.0,
                  color: Colors.white),
            bodyMedium: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white),
            bodyLarge: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w200,
                color: Colors.white),
            bodySmall: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w100,
                color: Colors.grey),
          )),
      home: HomePage(title: 'Rick and Morty'),
    );
  }
}
