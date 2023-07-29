import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class CharacterBlocObservable extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);

    //Выводим название блока, у которого произошел ивент и сам ивент
    log('onEvent --bloc: ${bloc.runtimeType}, event: $event');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    //Выводим название блока, у которого произошла ошибка и сама ошибка
    log('onError --bloc: ${bloc.runtimeType}, event: $error');

    //Также здесь можно подключить Firebase Analitics, куда будут попадать все ошибки приложения
  }
}