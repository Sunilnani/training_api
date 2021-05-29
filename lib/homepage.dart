import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_networkcalls/models/add_product_model.dart';
import 'package:flutter_networkcalls/models/products_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';
import 'network_calls/base_networks.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextController = TextEditingController();
  final descController = TextEditingController();
  final amountController = TextEditingController();
  Products products=Products();
  AddProducts add_product=AddProducts();
  bool _fetching = true;
  File img;

  void fetch_products() async {
    setState(() {
      _fetching = true;
    });
    try {
      SharedPreferences prefs= await SharedPreferences.getInstance();
      String access_token = prefs.get("access_token");
      Response response = await dioClient.ref.get("http://vps-d5b18cef.vps.ovh.net:5000/products",
          options: Options(
              validateStatus: (status) => status < 500,
              headers: {
                "Authorization":"Bearer $access_token"
              }
          )
      );
      setState(() {
        products = productsFromJson(jsonEncode(response.data));
        _fetching = false;
        print("accessed token is ${access_token}");

        // var variable=listTodos.forEach((element)=>print("bloody rock${element.channels.length}"));
      });
      print(response);
    } catch (e) {
      setState(() {
        _fetching = false;
      });
      print(e);
    }
  }

  ImagePicker imagePicker=ImagePicker();
  void galleryClick ()  async{
    PickedFile galary =await imagePicker.getImage(source: ImageSource.gallery);
    if (galary != null){
      setState(() {
        img=File(galary.path);
        print(img.path);
      });
    }
  }
  void addcategory()async{
    String  text = TextController.text.trim();
    String  desc=descController.text.trim();
    String  amount=amountController.text.trim();
    // String filename=file.path.split("/").last;
    FormData data = FormData.fromMap({
      "name":text,
      "description":desc,
      "amount":amount,
      "image":await MultipartFile.fromFile(img.path)
    });
    Response response =
    await Dio().post("http://vps-d5b18cef.vps.ovh.net:5000/product/add/" , data: data);
    setState(() {
      add_product = addProductsFromJson(jsonEncode(response.data)) ;

      print(response.data);
      print(response);
    });
  }
  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Category'),
            content: Container(
              height: 150,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: TextController,
                        decoration: InputDecoration(
                            hintText: "Enter name"
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: descController,
                        decoration: InputDecoration(
                            hintText: "description"
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: amountController,
                        decoration: InputDecoration(
                            hintText: "amount"
                        ),
                      ),
                    ),
                    RaisedButton(
                        child: Text("upload_image"),
                        onPressed: (){
                          setState(() {
                            galleryClick();
                          });
                        }),
                    RaisedButton(
                        child: Text("Submit"),
                        onPressed: (){
                          addcategory();
                          setState(() {

                          });
                        }),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Ok'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HomePage(
                      ),
                    ),
                  );
                },
              )
            ],
          );
        });
  }


  @override
  void initState() {
    fetch_products();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text("Products For Sale",style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold),),
          SizedBox(height: 20,),
          InkWell(
            onTap: (){
               _displayDialog(context);
            },
            child: Container(
              height: 30,
              width: 35,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: Colors.tealAccent),
              child: Icon(Icons.add,size: 20,),
            ),
          ),
          SizedBox(height: 30,),
          _fetching?Center(child: CircularProgressIndicator()):
          Container(
            height: 500,
            child: GridView.builder(
              itemCount: products.products.length,
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 15.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return products.products.isEmpty?Container(color: Colors.red,):
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),

                  child: Column(
                    children: [

                      CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        radius: 25,
                        child: Image.network("http://vps-d5b18cef.vps.ovh.net:5000${products.products[index].image}",width: 30,),
                      ),
                      SizedBox(height: 10,),
                      Container(
                          height: 20,
                          width: 50,
                          child: Text(products.products[index].name,style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 12),textAlign: TextAlign.center,)),
                      SizedBox(height: 5,),
                      Text(products.products[index].description,style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 12),textAlign: TextAlign.center,),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.pinkAccent,
                            child: Icon(Icons.add,size: 18,color: Colors.black,),
                          ),
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.pinkAccent,
                            child: Icon(Icons.edit,size: 18,color: Colors.black,),
                          )
                        ],
                      )

                    ],
                  ),
                );
              },
            ),
          )

        ],
      ),
    );
  }


}
