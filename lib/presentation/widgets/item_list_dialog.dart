import 'package:flutter/material.dart';
import '../../data/providers/dbhelper.dart';
import '../../data/models/list_items.dart';

class ItemListDialog {
  final txtName = TextEditingController();
  final txtQuantity = TextEditingController();
  final txtNote = TextEditingController();

  Widget buildAlert(BuildContext context, ListItem item, bool isNew) {
    DBHelper helper = DBHelper();
    if (!isNew) {
      txtName.text = item.name;
      txtQuantity.text = item.quantity;
      txtNote.text = item.note;
    }
    return AlertDialog(
      title: Text((isNew) ? 'New shopping item' : 'Edit shopping item'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: txtName,
              decoration: InputDecoration(
                hintText: 'Shopping item name'
              ),
            ),
            TextField(
              controller: txtQuantity,
              decoration: InputDecoration(
                hintText: 'Shopping item quantity'
              ),
            ),
            TextField(
              controller: txtNote,
              decoration: InputDecoration(
                hintText: 'Shopping item note'
              ),
            ),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () async {
                try {
                  item.name = txtName.text;
                  item.quantity = txtQuantity.text;
                  item.note = txtNote.text;
                  if (isNew) {
                    await helper.insertItem(item);
                  } else {
                    await helper.updateItem(item);
                  }
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