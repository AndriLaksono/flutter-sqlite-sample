import 'package:flutter/material.dart';
import '../../data/providers/dbhelper.dart';
import '../../data/models/shopping_list.dart';

class ShoppingListDialog {
  final txtName = TextEditingController();
  final txtPriority = TextEditingController();

  Widget buildDialog(BuildContext context, ShoppingList list, bool isNew) {
    DBHelper helper = DBHelper();
    if (!isNew) {
      txtName.text = list.name;
      txtPriority.text = list.priority.toString();
    }
    return AlertDialog(
      title: Text((isNew) ? 'New shopping list' : 'Edit shopping list'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: txtName,
              decoration: InputDecoration(
                hintText: 'Shopping list name'
              ),
            ),
            TextField(
              controller: txtPriority,
              decoration: InputDecoration(
                hintText: 'Shopping list priority (1-3)'
              ),
            ),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () async {
                try {
                  list.name = txtName.text;
                  list.priority = int.parse(txtPriority.text);
                  if (isNew) {
                    await helper.insertList(list);
                  } else {
                    await helper.updateList(list);
                  }
                  print('Edit woyyy');
                  Navigator.pop(context);
                } catch (e) {
                  print(e.toString());
                }
              }, 
            )
          ],
        )
      ),
    );
  }
}