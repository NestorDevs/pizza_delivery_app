import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pizza_delivery_app/app/models/menu_item_model.dart';

class ShoppingCardItem extends StatelessWidget {
  final MenuItemModel item;
  final numberFormat = NumberFormat.currency(
    name: 'R\$',
    locale: 'pt_BR',
    decimalDigits: 2,
  );

  ShoppingCardItem(
    this.item, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(item?.name ?? ''),
          Text('R\$ ${numberFormat.format(item?.price ?? 0.0)}'),
        ],
      ),
    );
  }
}
