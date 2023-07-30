import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rick_and_morty_app/bloc/character_bloc.dart';
import 'package:rick_and_morty_app/ui/widgets/custom_list_tile.dart';

import '../../data/models/character.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Character _currentCharacter; // Хранит инфу о страницах и персонажах
  List<Results> _currentResults = []; // Здесь будет массив персонажей
  int _currentPage = 1; // Здесь будет текущая страница
  String _currentSearchStr = ''; // Текущее значение поиска

  final RefreshController refreshController = RefreshController();
  bool _isPagination = false;

  Timer? searchDebounce;

  final _storage = HydratedBloc.storage;

  @override
  void initState() {
    if(_storage.runtimeType.toString().isEmpty){
      // При запуске приложения делаем запрос, если хранилище пустое
      if (_currentResults.isEmpty) {
        // Если масссив персонажей пустой, то делаем запрос
        context
            .read<CharacterBloc>()
            .add(const CharacterEvent.fetch(name: '', page: 1));
      }
    }

    // Получение данных
    context
        .read<CharacterBloc>()
        .add(const CharacterEvent.fetch(name: '', page: 1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CharacterBloc>().state; // Получаем состояние
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 15, bottom: 15, left: 16, right: 16),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            decoration: const InputDecoration(
                filled: true,
                fillColor: Color.fromRGBO(86, 86, 86, 0.8),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide.none),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                hintText: 'SearchName',
                hintStyle: TextStyle(color: Colors.white)),
            onChanged: (value) {
              _currentPage = 1; // Начало поиска
              _currentResults =
                  []; // Очищаем массив персонажей перед началом поиска
              _currentSearchStr = value;

              searchDebounce?.cancel();// Сброс таймера
              searchDebounce = Timer(const Duration(milliseconds: 500), () {
                context
                    .read<CharacterBloc>()
                    .add(CharacterEvent.fetch(name: value, page: _currentPage));
              });
            },
          ),
        ),
        Expanded(
          child: state.when(
              loading: () {
                if(!_isPagination){
                  return Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // Выравнивание оси по центру
                      children: const [
                        CircularProgressIndicator(strokeWidth: 2),
                        SizedBox(width: 10),
                        Text("Loading...")
                      ],
                    ),
                  );
                } else {
                  return _customListView(_currentResults);
                }
              },
              loaded: (characterLoaded) {
                _currentCharacter = characterLoaded;
                debugPrint('_currentCharacter $_currentCharacter');
                if(_isPagination){
                  _currentResults = List.from(_currentResults)..addAll(_currentCharacter.results); //Объединение массива текущих персонажей  и новых
                  refreshController.loadComplete();
                  _isPagination = false;
                } else {
                  _currentResults = _currentCharacter.results; // Записываем поле resuts из ответа
                }

                return _currentResults.isNotEmpty
                    ? _customListView(_currentResults)
                    : const SizedBox();
              },
              error: () => const Text("Data not found")),
        ),
      ],
    );
  }

  Widget _customListView(List<Results> currentResults) {
    // Обновление экрана при прокрутке

      return SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        enablePullDown: false,
        onLoading: () {
          _isPagination = true;
          _currentPage++;

          if(_currentPage <= _currentCharacter.info.pages){
            context.read<CharacterBloc>().add(CharacterEvent.fetch(name: _currentSearchStr, page: _currentPage));
          } else {
            refreshController.loadNoData();
          }
        },
        child: ListView.separated(
          separatorBuilder: (_, index) => const SizedBox(
            height: 5,
          ),
          itemCount: currentResults.length,
          shrinkWrap: true,
          // ListView будет занимать только нужное пространство в зависимости от количества элементов
          itemBuilder: (context, index) {
            final result = currentResults[index];
            return Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 3, bottom: 3),
              child: CustomListTile(result: result)
            );
          },
        ),
      );

  }
}
