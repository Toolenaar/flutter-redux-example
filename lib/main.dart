//from https://www.youtube.com/watch?v=Wj216eSBBWs
import 'package:flutter/material.dart';
import 'package:flutter_redux_example/model/model.dart';
import 'package:flutter_redux_example/redux/reducers.dart';
import 'package:flutter_redux_example/redux/actions.dart';
import 'package:flutter_redux_example/redux/middleware.dart';
import 'package:redux/redux.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';
import 'package:flutter_redux/flutter_redux.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DevToolsStore<AppState> store = DevToolsStore<AppState>(
        appStateReducer,
        initialState: AppState.initialState(),
        middleware: appStateMiddleware());
    // final Store<AppState> store =
    //     Store<AppState>(
    //       appStateReducer,
    //       initialState: AppState.initialState(),
    //       middleware: [appStateMiddleware]
    //       );

    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Flutter Redux example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StoreBuilder<AppState>(
            onInit: (store) => store.dispatch(GetItemsAction()),
            builder: (BuildContext context, Store<AppState> store) =>
                MyHomePage(title: 'Flutter redux example', store: store)),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final DevToolsStore<AppState> store;
  MyHomePage({Key key, this.title, this.store}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Container(
        color: Colors.white30,
        child: ReduxDevTools(store),
      ),
      appBar: AppBar(
        title: Text(title),
      ),
      body: StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) => _ViewModel.create(store),
        builder: (BuildContext context, _ViewModel viewModel) => Column(
              children: <Widget>[
                AddItemWidget(model: viewModel),
                Expanded(
                  child: ItemListWidget(model: viewModel),
                ),
                RemoveItemsButton(model: viewModel)
              ],
            ),
      ),
    );
  }
}

class _ViewModel {
  final List<Item> items;
  final Function(String) onAddItem;
  final Function(Item) onRemoveItem;
  final Function() onRemoveItems;
  final Function(Item) onCompleted;

  _ViewModel(
      {this.items,
      this.onAddItem,
      this.onRemoveItem,
      this.onRemoveItems,
      this.onCompleted});

  factory _ViewModel.create(Store<AppState> store) {
    _onAddItem(String body) {
      store.dispatch(AddItemAction(body));
    }

    _onRemoveItem(Item item) {
      store.dispatch(RemoveItemAction(item));
    }

    _onRemoveItems() {
      store.dispatch(RemoveItemsAction());
    }

    _onCompleted(Item item) {
      store.dispatch(ItemCompletedAction(item));
    }

    return _ViewModel(
        items: store.state.items,
        onAddItem: _onAddItem,
        onRemoveItem: _onRemoveItem,
        onCompleted: _onCompleted,
        onRemoveItems: _onRemoveItems);
  }
}

class AddItemWidget extends StatefulWidget {
  final _ViewModel model;

  AddItemWidget({Key key, this.model}) : super(key: key);

  _AddItemWidgetState createState() => _AddItemWidgetState();
}

class _AddItemWidgetState extends State<AddItemWidget> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(hintText: 'add an item'),
      onSubmitted: (String s) {
        widget.model.onAddItem(s);
        controller.text = '';
      },
    );
  }
}

class ItemListWidget extends StatelessWidget {
  final _ViewModel model;

  ItemListWidget({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: model.items
            .map((Item item) => ListTile(
                  title: Text(item.body),
                  trailing: Checkbox(
                    value: item.completed,
                    onChanged: (b) {
                      model.onCompleted(item);
                    },
                  ),
                  leading: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => model.onRemoveItem(item),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class RemoveItemsButton extends StatelessWidget {
  final _ViewModel model;

  RemoveItemsButton({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text('remove all items'),
      onPressed: () => model.onRemoveItems(),
    );
  }
}
