import 'package:flutter/material.dart';
import '../../routers/app_router.dart';
import '../../../data/providers/dbhelper.dart';
import '../../../data/models/shopping_list.dart';
import '../../widgets/shopping_list_dialog.dart';

class ShList extends StatefulWidget {
  final String title;
  ShList({Key key, this.title}) : super(key: key);

  @override
  _ShListState createState() => _ShListState();

}

class _ShListState extends State<ShList> {
  DBHelper _helper = DBHelper();
  List<ShoppingList> _shoppingList;

  // declare dialog widget
  ShoppingListDialog dialog;

  Future _showData() async {
    try {
      _shoppingList = await _helper.getLists();
      setState(() {
        _shoppingList = _shoppingList;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    dialog = ShoppingListDialog();
    _showData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh_rounded),
            onPressed: () {
              _showData();
            }
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: (_shoppingList != null) ? _shoppingList.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(_shoppingList[index].name),
            onDismissed: (direction) {
              String strName = _shoppingList[index].name;
              _helper.deleteList(_shoppingList[index]);
              setState(() {
                _shoppingList.removeAt(index);
              });
              Scaffold.of(context).showSnackBar(
                SnackBar(content: Text('$strName deleted'))
              );
            },
            child: ListTile(
              leading: CircleAvatar(
                child: Text(_shoppingList[index].priority.toString()),
              ),
              title: Text(_shoppingList[index].name),
              trailing: IconButton(
                icon: Icon(Icons.edit), 
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext ctx) => dialog.buildDialog(ctx, _shoppingList[index], false)
                  );
                }
              ),
              onTap: () {
                Navigator.of(context).pushNamed(AppRouter.items, arguments: _shoppingList[index]);
              },
            ),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.green,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext ctx) => dialog.buildDialog(ctx, ShoppingList(id: 0, name: '', priority: 0), true)
          );
        }
      ),
    );
  }
}