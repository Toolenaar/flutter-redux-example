import 'package:flutter/foundation.dart';

class Item {
  final int id;
  final String body;
  final bool completed;
  Item({@required this.id, @required this.body, this.completed = false});

  Item copyWith({int id, String body,bool completed}) {
    return Item(
        body: body ?? this.body,
        id: id ?? this.id,
        completed: completed ?? this.completed);
  }

  Item.fromJson(Map json)
      : body = json['body'],
        completed = json['completed'],
        id = json['id'];

  Map toJson() => {'id': (id as int), 'body': body, 'completed': completed};

  @override
  String toString() {
    return toJson().toString();
  }

}

class AppState {
  final List<Item> items;

  const AppState({@required this.items});

  AppState.initialState() : items = List.unmodifiable(<Item>[]);

  AppState.fromJson(Map json)
      : items = (json['items'] as List).map((i) => Item.fromJson(i)).toList();

  Map toJson() => {'items': items};


  @override
  String toString() {
    return toJson().toString();
  }

}
