import 'package:flutter/material.dart';
import '../../../data/models/list_items.dart';
import '../../../data/models/shopping_list.dart';
import '../../../data/providers/dbhelper.dart';
import '../../widgets/item_list_dialog.dart';


class ItemsScreen extends StatefulWidget {
  final ShoppingList shoppingList;
  ItemsScreen(this.shoppingList);

  @override
  _ItemsScreenState createState() => _ItemsScreenState(this.shoppingList);
}

class _ItemsScreenState extends State<ItemsScreen> {
  
  final ShoppingList shoppingList;
  _ItemsScreenState(this.shoppingList);

  DBHelper _helper = DBHelper();
  List<ListItem> _items;

  // declare dialog item widget
  ItemListDialog dialog;

  Future _showData(int idList) async {
    try {
      await _helper.openDB();
      _items = await _helper.getItems(idList);
      setState(() {
        _items = _items;
      });
    } catch (e) {
      print(e.toString() + " WOY");
    }
  }

  @override
  void initState() {
    dialog = ItemListDialog();
    _showData(this.shoppingList.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(shoppingList.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _showData(this.shoppingList.id);
            }
          )
        ],
      ),
      body: ListView.builder(
        itemCount: (_items != null) ? _items.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(_items[index].name), 
            onDismissed: (direction) async {
              String strName = _items[index].name;
              await _helper.deleteItem(_items[index]);
              setState(() {
                _items.removeAt(index);
              });
              Scaffold.of(context).showSnackBar(
                SnackBar(content: Text('$strName deleted!'))
              );
            },
            child: ListTile(
              title: Text(_items[index].name),
              subtitle: Text('Quantity: ${_items[index].quantity} - Note: ${_items[index].note}'),
              onTap: (){},
              trailing: IconButton(
                icon: Icon(Icons.edit), 
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext ctx) => dialog.buildAlert(ctx, _items[index], false)
                  );
                }
              ),
            )
          );
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.green,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext ctx) => dialog.buildAlert(ctx, 
              ListItem(id: 0, listId: shoppingList.id, name: '', quantity: '', note: ''), true)
          );
        }
      ),
    );
  }
}