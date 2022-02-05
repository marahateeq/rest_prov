import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rest_prov/providers/product.dart';
import 'package:rest_prov/providers/products.dart';
import 'package:rest_prov/screens/manage_products_screen.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/EditProductScreen';
  const EditProductScreen({Key key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {

  final _categoryFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formkey = GlobalKey<FormState>();

  String valueChoose;

  List ListCategory = [
    "Food","Drinks","Salad","Desserts"
  ];

  var _editedProduct = Product( // in case you want to modify the product values
      id: null,
      title: '',
      category: '',
      description: '',
      price: 0,
      imageUrl: ''
  );

  var _initialValues = {
    'title': '',
    'category': '',
    'description': '',
    'price' : '',
    'imageUrl': ''
  };

  var _isInit = true ;
  var _isLoading = false ;

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override // إعادة البناء في كل مرة يحدث فيها تحديث داخل البيانات التي تحضرها
  void didChangeDependencies() { // rebuild every time an update happens inside data that you bring
    // run only one time تنفيذ مرة واحدة فقط
    super.didChangeDependencies();
    if(_isInit){ // if _isInit == true
      final productId = ModalRoute.of(context).settings.arguments  as String;

      if(productId != null ){ // update
        _editedProduct = Provider.of<Products>(context , listen: false).findById(productId );
        _initialValues = {
          'title': _editedProduct.title,
          'category': _editedProduct.category,
          'description': _editedProduct.description,
          'price' : _editedProduct.price.toString(),
          'imageUrl': ''
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
      _isInit = false ;
    }
  }

  @override
  void dispose() { // distroy variables
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _categoryFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();

  }

  void _updateImageUrl() {
    if(!_imageUrlFocusNode.hasFocus){ // check if it is valid
      if((   !_imageUrlController.text.startsWith('http')
          && !_imageUrlController.text.startsWith('https'))
          || (!_imageUrlController.text.endsWith('.png')
              && !_imageUrlController.text.endsWith('.jpg')
              && !_imageUrlController.text.endsWith('.jpeg'))
      ){
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async{
    final isValid = _formkey.currentState.validate(); // false or true
    if(!isValid){ // false
      return;
    }
    _formkey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if(_editedProduct.id != null){
      await Provider.of<Products>(context , listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    }else{
      try{
        await Provider.of<Products>(context , listen: false)
            .addProduct(_editedProduct);

      }catch(e){
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('An error occured'),
              content: Text('Something went wrong!'),
              actions: [
                TextButton(
                  child: Text('Ok'),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            )
        );
      }
      // bn Navigator.of(context).pushNamed(ManageProductsScreen.routeName);

    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add product'),
        actions: [
          IconButton(
              onPressed :  _saveForm,
              icon: Icon(Icons.save))
        ],
      ),

      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formkey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initialValues['title'] as String,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value){
                  if(value.isEmpty ){
                    return 'Please provide a value';
                  } return null;
                },
                onSaved: (value){
                  _editedProduct = Product(

                    id: _editedProduct.id,
                    title: value,
                    category: _editedProduct.category,
                    description: _editedProduct.description,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
              ),


              TextFormField(
                initialValue: _initialValues['price']  ,
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value){
                  if(value.isEmpty ){
                    return 'Please enter a valid price.';
                  }
                  if(double.tryParse(value) == null ){
                    return 'Please enter a valid number.';
                  }
                  if(double.parse(value) <= 0 ){
                    return 'Please enter a number greater than zero.';
                  }
                  return null;
                },
                onSaved: (value){
                  _editedProduct = Product(

                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    category: _editedProduct.category,
                    description: _editedProduct.description,
                    price: double.parse(value as String),
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
              ),


              TextFormField(
                initialValue: _initialValues['description'] as String,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                validator: (value){
                  if(value.isEmpty ){
                    return 'Please enter a description.';
                  }
                  if(value.length <10){
                    return 'Should be at least 10 characters long.';
                  }
                  return null;
                },
                onSaved: (value){
                  _editedProduct = Product(
                    //restaurantId: '',
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    category: _editedProduct.category,
                    description: value as String,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
              ),

              SizedBox(height: 30,),
              Container(

                  child: Padding(

                    padding: const EdgeInsets.all(10.0),
                    child: Container(

                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey , width: 0.5),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: DropdownButton(
                        hint: _editedProduct.id==null?
                        Text('    Select Category' ,style: TextStyle(fontSize: 15),):
                        Text('   ${_editedProduct.category}' , style: TextStyle(fontSize: 15),),
                        dropdownColor: Colors.deepOrange,
                        icon: Icon(Icons.arrow_drop_down , color: Colors.deepOrange,),
                        iconSize: 40,
                        isExpanded: true,
                        underline: SizedBox(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15
                        ),
                        value: valueChoose,
                        onChanged: (newValue){
                          setState(() {
                            valueChoose = newValue;
                            _editedProduct = Product(

                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              category: newValue,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                              isFavorite: _editedProduct.isFavorite,
                            );

                          });
                        },

                        items: ListCategory.map((valueCategory) {
                          return DropdownMenuItem(
                              value: valueCategory,
                              child: Text(valueCategory)
                          );

                        }).toList(),
                      ),
                    ),
                  )
              ),

              SizedBox(height: 20,),





              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1 , color: Colors.grey),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a URL ')
                        : FittedBox(
                      //alignment: Alignment.topRight,
                      child: Image.network(
                        _imageUrlController.text,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _imageUrlController,
                      decoration: InputDecoration(
                        labelText: 'Image URL',
                      ),
                      keyboardType: TextInputType.url,
                      focusNode: _imageUrlFocusNode,
                      validator: (value){
                        if(value.isEmpty ){
                          return 'Please enter a image URL.';
                        }
                        if(!value.startsWith('http') && !value.startsWith('https') ){
                          return 'Please enter a valid URL.';
                        }
                        if(!value.endsWith('png') && !value.endsWith('jpg') && !value.endsWith('jpeg') ){
                          return 'Please enter a valid URL.';
                        }

                        return null;
                      },
                      onSaved: (value){
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          category: _editedProduct.category,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: value as String,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                  ),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }


}
