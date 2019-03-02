import 'package:flutter/foundation.dart';

class Item {
  final int id;
  final String body;
  Item({@required this.id, @required this.body});

  Item copyWith({int id, String body}) {
    return Item(body: body ?? this.body, id: id ?? this.id);
  }
}

class AppState {
  final List<Item> items;

  AppState({
    @required this.items
  });

  AppState.initialState() : items = List.unmodifiable(<Item>[]);

}
