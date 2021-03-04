import 'package:flutter/foundation.dart';

class ListItem {
  int id;
  int listId;
  String name;
  String quantity;
  String note;

  ListItem({
    @required this.id,
    @required this.listId,
    @required this.name,
    @required this.quantity,
    @required this.note
  });

  Map<String, dynamic> toMap() {
    return {
      'id': (id==0) ? null : id,
      'list_id': listId,
      'name': name,
      'quantity': quantity,
      'note': note,
    };
  }
}