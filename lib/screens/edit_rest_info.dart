import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rest_prov/providers/restuarant.dart';
import 'package:rest_prov/providers/restuarants.dart';
import 'package:rest_prov/screens/homepage.dart';

class EditResInfo extends StatefulWidget {
  static const routeName = '/EditResInfo';
  const EditResInfo({Key key}) : super(key: key);

  @override
  _EditResInfoState createState() => _EditResInfoState();
}

class _EditResInfoState extends State<EditResInfo> {

  final _addressFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formkey = GlobalKey<FormState>();

  var _editedRes = Restaurant( // in case you want to modify the restaurant values
      id: null,
      name: '',
      address: '',
      imageUrl: ''
  );

  var _initialValues = {
    'name': '',
    'address': '',
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
      final resId = ModalRoute.of(context).settings.arguments  as String;

      if(resId != null ){ // update
        _editedRes = Provider.of<Restaurants>(context , listen: false).findById(resId);
        _initialValues = {
          'name': _editedRes.name,
          'address': _editedRes.address,
          'imageUrl': ''
        };
        _imageUrlController.text = _editedRes.imageUrl;
      }
      _isInit = false ;
    }
  }

  @override
  void dispose() { // distroy variables
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _addressFocusNode.dispose();
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

    if(_editedRes.id != null){
      await Provider.of<Restaurants>(context , listen: false)
          .updateRest(_editedRes.id, _editedRes);
    }else {
      try {
        await Provider.of<Restaurants>(context, listen: false)
            .addRestaurant(_editedRes);
      } catch (e) {
        print(e);
        await showDialog(
            context: context,
            builder: (ctx) =>
                AlertDialog(
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
      } //catch
    }
    setState(() {
      _isLoading = false;
    });
    //Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed(HomePage.routeName , //arguments:_editedRes
    );
  }

  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant Information'),
        actions: [
          IconButton(
              onPressed :  _saveForm ,
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
                initialValue: _initialValues['name'] as String,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_addressFocusNode);
                },
                validator: (value){
                  if(value.isEmpty ){
                    return 'Please provide a value';
                  } return null;
                },
                onSaved: (value){
                  _editedRes = Restaurant(

                    id: _editedRes.id,
                    name: value,
                    address: _editedRes.address,
                    imageUrl: _editedRes.imageUrl,
                  );
                },
              ),


              TextFormField(
                initialValue: _initialValues['address']  ,
                decoration: InputDecoration(
                  labelText: 'Address',
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                focusNode: _addressFocusNode,
                validator: (value){
                  if(value.isEmpty ){
                    return 'Please enter your restaurant address.';
                  }

                  return null;
                },
                onSaved: (value){
                  _editedRes = Restaurant(

                    id: _editedRes.id,
                    name: _editedRes.name,
                    address: value,
                    imageUrl: _editedRes.imageUrl,
                  );
                },
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
                        _editedRes = Restaurant(
                          id: _editedRes.id,
                          name: _editedRes.name,
                          address: _editedRes.address,
                          imageUrl: value as String,
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
