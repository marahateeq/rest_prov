import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rest_prov/providers/products.dart';
import 'package:rest_prov/screens/edit_product_screen.dart';

class ProductItem extends StatelessWidget {
final String id;
final String title;
final String imageUrl;

const ProductItem(
   this.id,
   this.title,
   this.imageUrl,
);
Image imageFromBase64String(String base64String) {
  return Image.memory(base64Decode(base64String));
}

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: imageFromBase64String(imageUrl).image,
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => Navigator.of(context).pushNamed(EditProductScreen.routeName , arguments: id),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async{
                try{
                  await Provider.of<Products>(context , listen: false).deleteProduct(id);
                }catch(e){
                   scaffold.showSnackBar(SnackBar(
                       content: Text('Deleting failed ! ',
                         textAlign: TextAlign.center,)),

                   );
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),

    );
  }
}
