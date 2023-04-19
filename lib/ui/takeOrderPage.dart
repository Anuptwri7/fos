import 'dart:convert';
import 'dart:developer';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:fos/models/category.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../consts/string_const.dart';
import '../consts/style_const.dart';
import '../models/food.dart';
import '../models/orderSummary.dart';
import '../models/subCategory.dart';
import '../models/tableOrder.dart';
import 'homePage.dart';

class TakeOrderPage extends StatefulWidget {
  String? tableName;
  String? tableNo;
  int? status;

  TakeOrderPage({Key? key, this.tableName, this.tableNo,this.status}) : super(key: key);

  @override
  State<TakeOrderPage> createState() => _TakeOrderPageState();
}

class _TakeOrderPageState extends State<TakeOrderPage> {
  int quantity=0;
  String dropdownvalueCategory = 'Select Category';
  String _selectedCategory = '';
  String dropdownvalueSubCategory = 'Select Sub Category';
  String _selectedSubCategory = '';
  String dropdownvalueFood = 'Select Food';
  String _selectedFood = '';
  List foodOrdersiD = [];
  List foodOrders = [];
  List unit = [];
  List remarks = [];
  List qty = [];
  List finalOrders = [];
  int orderCount=0;
List masterId=[];
String unitName='';

  void add() {
    setState(() {
      quantity++;
    });
  }
  void minus() {
    setState(() {
      if (quantity != 0)
        quantity--;
    });
  }


@override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderMaster();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Take Order for ${widget.tableName}",
            style: TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          // backgroundColor: Color(0xff2c51a4),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            Visibility(
              visible: widget.status==3?false:true,
              child: IconButton(
                icon: const Icon(
                  Icons.cancel_outlined,
                  color: Color(0xffBF1E2E),
                  size: 30,
                ),
                onPressed: () async {
                  openDiaolgForCancelOrder(context);
                },
              ),
            ),
            Visibility(
              visible: widget.status==3?false:true,
              child: InkWell(
                onTap: () =>
                 {}
                ,
                child: Stack(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.done_all,
                        color: Colors.green,
                        size: 30,
                      ),
                      onPressed: () async {
                        openDiaolgForCompleteOrder(context);
                      },
                    ),

                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Visibility(
                visible: widget.status==3?false:true,
                child: Container(
                  margin: EdgeInsets.all(4.0),
                  padding: EdgeInsets.all(4.0),
                  decoration: kFormBoxDecoration,
                  width: MediaQuery.of(context).size.width,
                  child: FutureBuilder(
                    future: fetchCategory(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasError) {
                        return Text("Loading");
                      }
                      if (snapshot.hasData) {
                        try {
                          final List<Results> snapshotData = snapshot.data;
                          return DropdownButton<Results>(
                            elevation: 24,
                            isExpanded: true,
                            hint: Text(
                                "${dropdownvalueCategory.isEmpty ? "Select Category" : dropdownvalueCategory}"),
                            // value: snapshotData.first,
                            iconSize: 24.0,
                            icon: Icon(
                              Icons.arrow_drop_down_circle,
                              color: Colors.grey,
                            ),

                            underline: Container(
                              height: 2,
                              color: Colors.white,
                            ),
                            items: snapshotData
                                .map<DropdownMenuItem<Results>>((Results items) {
                              return DropdownMenuItem<Results>(
                                value: items,
                                child: Text(items.name.toString()),
                              );
                            }).toList(),
                            onChanged: (Results? Value) {
                              setState(
                                () {
                                  dropdownvalueCategory = Value!.name.toString();
                                  _selectedCategory = Value.id.toString();
                                },
                              );
                            },
                          );
                        } catch (e) {
                          throw Exception(e);
                        }
                      } else {
                        return Text(snapshot.error.toString());
                      }
                    },
                  ),
                ),
              ),
              Visibility(
                visible: widget.status==3?false:true,
                child: Container(
                  margin: EdgeInsets.all(4.0),
                  padding: EdgeInsets.all(4.0),
                  decoration: kFormBoxDecoration,
                  width: MediaQuery.of(context).size.width,
                  child: FutureBuilder(
                    future: fetchSubCategory(_selectedCategory.toString()),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasError) {
                        return Text("Select Category");
                      }
                      if (snapshot.hasData) {
                        try {
                          final List<SubCategoryResults> snapshotData =
                              snapshot.data;
                          return DropdownButton<SubCategoryResults>(
                            elevation: 24,
                            isExpanded: true,
                            hint: Text(
                                "${dropdownvalueSubCategory.isEmpty ? "Select Sub Category" : dropdownvalueSubCategory}"),
                            // value: snapshotData.first,
                            iconSize: 24.0,
                            icon: Icon(
                              Icons.arrow_drop_down_circle,
                              color: Colors.grey,
                            ),

                            underline: Container(
                              height: 2,
                              color: Colors.white,
                            ),
                            items: snapshotData
                                .map<DropdownMenuItem<SubCategoryResults>>(
                                    (SubCategoryResults items) {
                              return DropdownMenuItem<SubCategoryResults>(
                                value: items,
                                child: Text(items.name.toString()),
                              );
                            }).toList(),
                            onChanged: (SubCategoryResults? Value) {
                              setState(
                                () {
                                  dropdownvalueSubCategory =
                                      Value!.name.toString();
                                  _selectedSubCategory = Value.id.toString();
                                },
                              );
                            },
                          );
                        } catch (e) {
                          throw Exception(e);
                        }
                      } else {
                        return Text(snapshot.error.toString());
                      }
                    },
                  ),
                ),
              ),

              Visibility(
                visible: widget.status==3?false:true,
                child: Container(
                  margin: EdgeInsets.all(4.0),
                  padding: EdgeInsets.all(4.0),
                  decoration: kFormBoxDecoration,
                  width: MediaQuery.of(context).size.width,
                  child: FutureBuilder(
                    future: fetchFoodList(_selectedCategory.toString(),
                        _selectedSubCategory.toString()),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasError) {
                        return Text("Select SubCategory");
                      }
                      if (snapshot.hasData) {
                        try {
                          final List<FoodResults> snapshotData = snapshot.data;
                          return DropdownButton<FoodResults>(
                            elevation: 24,
                            isExpanded: true,
                            hint: Text(
                                "${dropdownvalueFood.isEmpty ? "Select Sub Category" : dropdownvalueFood}"),
                            // value: snapshotData.first,
                            iconSize: 24.0,
                            icon: Icon(
                              Icons.arrow_drop_down_circle,
                              color: Colors.grey,
                            ),

                            underline: Container(
                              height: 2,
                              color: Colors.white,
                            ),
                            items: snapshotData.map<DropdownMenuItem<FoodResults>>(
                                (FoodResults items) {
                              return DropdownMenuItem<FoodResults>(
                                value: items,
                                child: Text(items.name.toString()),
                              );
                            }).toList(),
                            onChanged: (FoodResults? Value) {
                              setState(
                                () {
                                  unitName = Value!.unitName.toString();
                                  dropdownvalueFood = Value.name.toString();
                                  _selectedFood = Value.id.toString();
                                },
                              );
                            },
                          );
                        } catch (e) {
                          throw Exception(e);
                        }
                      } else {
                        return Text(snapshot.error.toString());
                      }
                    },
                  ),
                ),
              ),
              Visibility(
                visible: widget.status==3?false:true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                     FloatingActionButton(
                      onPressed: add,
                      child:  Icon(Icons.add, color: Colors.black,),
                      backgroundColor: Colors.white,),

                     Text('$quantity',
                        style:  TextStyle(fontSize: 60.0)),

                     FloatingActionButton(
                      onPressed: minus,
                      child:  Icon(
                           Icons.minimize,
                          color: Colors.black),
                      backgroundColor: Colors.white,),
                  ],
                ),
              ),
              // Visibility(
              //   visible: widget.status==3?false:true,
              //   child: TextFormField(
              //     // The validator receives the text that the user has entered.
              //     validator: (value) {
              //       if (value == null || value.isEmpty) {
              //         return 'Please Enter the Quantity';
              //       }
              //     },
              //     cursorColor: Color(0xff3667d4),
              //     keyboardType: TextInputType.name,
              //     onChanged: (value) {
              //       quantity = value;
              //     },
              //     style: TextStyle(color: Colors.grey),
              //     decoration: kFormFieldDecoration.copyWith(
              //       hintText: 'Quantity',
              //       prefixIcon: const Icon(
              //         Icons.production_quantity_limits,
              //         color: Colors.grey,
              //       ),
              //     ),
              //   ),
              // ),

              Visibility(
                visible: widget.status==3?false:true,
                child: Padding(
                  padding: const EdgeInsets.only(top:30.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff424143),
                      ),
                      onPressed: () {
                        setState(() {
                          foodOrdersiD.add(_selectedFood);
                          foodOrders.add(dropdownvalueFood);
                          unit.add(unitName);
                          qty.add(quantity);
                          quantity = 0;
                        });

                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage())),
                      },
                      child: Text(
                        "Add",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ),
              Visibility(
                visible: widget.status==3?false:true,
                child: Visibility(
                  visible: qty.isEmpty ? false : true,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: DataTable(
                        sortColumnIndex: 0,
                        columnSpacing: 190,
                        horizontalMargin: 0,
                        // columnSpacing: 10,
                        columns: [
                          DataColumn(
                            label: SizedBox(
                              child: const Text('Food'),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              child: const Text('Quantity'),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              child: const Text('Unit'),
                            ),
                          ),
                        ],
                        rows: List.generate(
                            qty.length,
                            (index) => DataRow(
                                  // selected: true,
                                  cells: [
                                    DataCell(
                                      Text(
                                        foodOrders[index].toString(),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        qty[index].toString(),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        unit[index].toString(),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                )),
                      ),
                    ),
                  ),
                ),
              ),
              // Visibility(
              //   visible: qty.isEmpty ? false : true,
              //   child: ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //         primary: Color(0xff424143),
              //       ),
              //       onPressed: () => placeOrder()
              //       // Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage())),
              //
              //       ,
              //       child: Text(
              //         "Place Order",
              //         style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 14,
              //             fontWeight: FontWeight.bold),
              //       )),
              // ),
              FutureBuilder<List<TableResults>?>(
                  future: fetchSummary(),
                  builder: (context, snapshot) {
                    log("snapshot"+snapshot.data.toString());
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(
                            child: CircularProgressIndicator());
                      default:
                        if (snapshot.hasError) {
                          return Text('No Orders Yet');
                        } else {
                          return getTableResultsList(snapshot.data);
                        }
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
  getTableResultsList(List<TableResults>? data) {

    return data != null
        ? ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount:1 ,
        // physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              margin: kMarginPaddSmall,
              color: Colors.white,
              elevation: kCardElevation,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    widget.status==3?DataTable(
                sortColumnIndex: 0,
                  columnSpacing: 180,
                  horizontalMargin: 0,
                  // columnSpacing: 10,
                  columns: [
                    DataColumn(
                      label: SizedBox(
                        child: const Text('Food'),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        child: const Text('Quantity'),
                      ),

                    ),
                    DataColumn(
                      label: SizedBox(
                        child: const Text('Unit'),
                      ),

                    ),
                  ],
                  rows: List.generate(
                      data.length,
                          (index) => DataRow(
                        // selected: true,
                        cells: [
                          DataCell(
                            Text(
                              data[index].food!.name.toString(),
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataCell(
                            Text(
                              data[index].qty.toString(),
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataCell(
                            Text(
                              data[index].food!.unitName.toString(),
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),

                        ],
                      )),
                ):
                ExpandablePanel(
                header: Container(
                margin: kMarginPaddSmall,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Orders',
                        style: kTextStyleBlack,
                      ),
                    ],
                  ),
                ),
                expanded: const Divider(),
                collapsed: Center(
              child: DataTable(
              sortColumnIndex: 0,
              columnSpacing: 180,
              horizontalMargin: 0,
              // columnSpacing: 10,
              columns: [
                DataColumn(
                  label: SizedBox(
                    child: const Text('Food'),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    child: const Text('Quantity'),
                  ),

                ),
                DataColumn(
                  label: SizedBox(
                    child: const Text('Unit'),
                  ),

                ),
                DataColumn(
                  label: SizedBox(
                    child: const Text('Action'),
                  ),

                ),
              ],
              rows: List.generate(
                  data.length,
                      (index) => DataRow(
                    // selected: true,
                    cells: [
                      DataCell(
                        Text(
                          data[index].food!.name.toString(),
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataCell(
                        Text(
                          data[index].qty.toString(),
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataCell(
                        Text(
                          data[index].food!.unitName.toString(),
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataCell(
                          GestureDetector(
                              onTap: (){
                                openDiaolgForExit(context,data[index].id.toString());
                              },
                              child: Icon(Icons.delete,color: Colors.red,))
                      ),
                    ],
                  )),
            ),
          ),


              ),

                    Visibility(
                      visible: widget.status==3?false:true,
                      child: Visibility(
                        visible: data.isEmpty&&qty.isNotEmpty ? true : false,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xff424143),
                            ),
                            onPressed: () => placeOrder()
                            // Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage())),

                            ,
                            child: Text(
                              "Place Order",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ),
                    Visibility(
                      visible: widget.status==3?false:true,
                      child: Visibility(
                        visible: data.isEmpty?false:true,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xff424143),
                            ),
                            onPressed: () {
                              updateOrder();
                              // Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage())),
                            },
                            child: Text(
                              "Update Order",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ),
                  ],
                ),

              ),

            ),
          );
        })
        : Center(
      child: Text(
        'Loading',
        style: kTextStyleBlack,
      ),
    );
  }
  Future fetchCategory() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    // log(sharedPreferences.getString("access_token"));
    final response = await http.get(
        Uri.parse(StringConst.mainUrl + StringConst.getCategoryList),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
        });

    // log(response.body.toString());
    List<Results> respond = [];

    final responseData = json.decode(response.body);
    responseData['results'].forEach(
      (element) {
        respond.add(
          Results.fromJson(element),
        );
      },
    );
    if (response.statusCode == 200) {
      return respond;
    }
  }
  Future fetchSubCategory(String category) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    // log(sharedPreferences.getString("access_token"));
    final response = await http.get(
        Uri.parse(
            StringConst.mainUrl + StringConst.getSubCategoryList + category),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
        });

    // log(response.body.toString());
    List<SubCategoryResults> respond = [];

    final responseData = json.decode(response.body);
    responseData['results'].forEach(
      (element) {
        respond.add(
          SubCategoryResults.fromJson(element),
        );
      },
    );
    if (response.statusCode == 200) {
      return respond;
    }
  }
  Future fetchFoodList(String category, String subCategory) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    // log(sharedPreferences.getString("access_token"));
    final response = await http.get(
        Uri.parse(
            '${StringConst.mainUrl}${StringConst.foodList}?category=$category&sub_category=$subCategory'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
        });

    log("food"+response.body.toString());
    List<FoodResults> respond = [];

    final responseData = json.decode(response.body);
    responseData['results'].forEach(
      (element) {
        respond.add(
          FoodResults.fromJson(element),
        );
      },
    );
    if (response.statusCode == 200) {
      return respond;
    }
  }
  Future<List<TableResults>?>? fetchSummary() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse(StringConst.mainUrl + StringConst.tableOrder+'${widget.tableNo}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
        });

    List<TableResults> respond = [];

    log(StringConst.mainUrl + StringConst.tableOrder+'${widget.tableNo}');
log(response.body);
    final responseData = json.decode(response.body);
    responseData['results'].forEach(
          (element) {
        respond.add(
          TableResults.fromJson(element),
        );
      },
    );
    if (response.statusCode == 200) {
      return respond;
    }else{

    }
  }
  Future<List<TableResults>?>? orderMaster() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse(StringConst.mainUrl + StringConst.placeOrder+'?table=${widget.tableNo}&cancelled=false&active=true'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
        });

    List<TableResults> respond = [];

    log(StringConst.mainUrl + StringConst.placeOrder+'?table=${widget.tableNo}');
    log("master"+response.statusCode.toString());
    final responseData = json.decode(response.body);
    responseData['results'].forEach(
          (element) {
        respond.add(
          TableResults.fromJson(element),
        );
      },
    );

    if (response.statusCode == 200) {
      for(int i=0;i<jsonDecode(response.body)['results'].length;i++){
        setState(() {
          masterId.add(jsonDecode(response.body)['results'][i]['id']);
          log("master id"+masterId.toString());
        });
      }

      return respond;
    }else{

    }
  }
  Future placeOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List finalOrderToPlace = [];
    for (int i = 0; i < qty.length; i++) {
      finalOrderToPlace
          .add({"qty": qty[i], "remarks": "string", "food": foodOrdersiD[i]});
    }
    var response = await http.post(
      Uri.parse('${StringConst.mainUrl}${StringConst.placeOrder}'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${prefs.get("access_token")}'
      },
      body: (jsonEncode(
        {
          "order_details": finalOrderToPlace,
          "remarks": "string",
          "table": widget.tableNo
        }
      )),
    );

    log('${StringConst.mainUrl}${StringConst.placeOrder}');
    log(response.body.toString());
    if (response.statusCode == 200||response.statusCode==201) {
      setState(() {
        qty.clear();
        foodOrdersiD.clear();
        foodOrders.clear();
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
    } else {
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
      // Fluttertoast.showToast(msg: "${json.decode(response.body)}");
    }
  }
  Future updateOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List finalOrderToPlace = [];
    for (int i = 0; i < qty.length; i++) {
      finalOrderToPlace
          .add({"qty": qty[i], "remarks": "string", "food": foodOrdersiD[i]});
    }
    var response = await http.patch(
      Uri.parse('${StringConst.mainUrl}${StringConst.updateOrder}${masterId[0]}'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${prefs.get("access_token")}'
      },
      body: (jsonEncode(
          {
            "order_details": finalOrderToPlace,
            "table": widget.tableNo
          }
      )),
    );

    log('${StringConst.mainUrl}${StringConst.updateOrder}${masterId[0]}');
    log('$finalOrderToPlace');
    log(response.statusCode.toString());
    if (response.statusCode == 200||response.statusCode==201) {
      setState(() {
        qty.clear();
        foodOrdersiD.clear();
        foodOrders.clear();
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
    } else {
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
      // Fluttertoast.showToast(msg: "${json.decode(response.body)}");
    }
  }
  Future completeOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List finalOrderToPlace = [];
    for (int i = 0; i < qty.length; i++) {
      finalOrderToPlace
          .add({"qty": qty[i], "remarks": "string", "food": foodOrdersiD[i]});
    }
    var response = await http.patch(
      Uri.parse('${StringConst.mainUrl}${StringConst.completeOrder}${masterId[0]}'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${prefs.get("access_token")}'
      },

    );

    log('${StringConst.mainUrl}${StringConst.updateOrder}${masterId[0]}');
    log('$finalOrderToPlace');
    log(response.statusCode.toString());
    if (response.statusCode == 200||response.statusCode==201) {
      masterId.clear();

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
    } else {
      masterId.clear();

      // Fluttertoast.showToast(msg: "${json.decode(response.body)}");
    }
  }
  Future cancelOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List finalOrderToPlace = [];
    for (int i = 0; i < qty.length; i++) {
      finalOrderToPlace
          .add({"qty": qty[i], "remarks": "string", "food": foodOrdersiD[i]});
    }
    var response = await http.patch(
      Uri.parse('${StringConst.mainUrl}${StringConst.cancelOrder}${masterId[0]}'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${prefs.get("access_token")}'
      },

    );

    log('${StringConst.mainUrl}${StringConst.cancelOrder}${masterId[0]}');
    log('$finalOrderToPlace');
    log(response.statusCode.toString());
    if (response.statusCode == 200||response.statusCode==201) {
      masterId.clear();

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
    } else {
      masterId.clear();

      // Fluttertoast.showToast(msg: "${json.decode(response.body)}");
    }
  }
  Future cancelDetail(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var response = await http.patch(
      Uri.parse('${StringConst.mainUrl}${StringConst.cancelDetail+id}'),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${prefs.get("access_token")}'
      },

    );

    log(response.body.toString());
    if (response.statusCode == 200||response.statusCode==201) {
      setState(() {

      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
    } else {
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
      // Fluttertoast.showToast(msg: "${json.decode(response.body)}");
    }
  }
  Future openDiaolgForCompleteOrder(BuildContext context) =>
      showDialog(
        barrierColor: Colors.black38,

        context: context,

        builder: (context) => Dialog(
          backgroundColor: Colors.indigo.shade50,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  // height:600,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top:20.0),
                          child: Text("Are you sure want to complete?",style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                  ),
                                  onPressed: ()=>{
                                   completeOrder(),
                                    Navigator.pop(context)
                                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage())),
                                    // login()
                                  },
                                  child: Text("Yes",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),)
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                  ),

                                  onPressed: ()=>{
                                    Navigator.pop(context)
                                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage())),
                                    // login()
                                  },
                                  child: Text("No",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),)
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                ),
              ),
              Positioned(
                  top:-35,

                  child: CircleAvatar(
                    child: Icon(Icons.cancel,size: 40,),
                    radius: 40,

                  )),

            ],
          ),
        ),

      );
  Future openDiaolgForCancelOrder(BuildContext context) =>
      showDialog(
        barrierColor: Colors.black38,

        context: context,

        builder: (context) => Dialog(
          backgroundColor: Colors.indigo.shade50,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  // height:600,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top:20.0),
                          child: Text("Are you sure want to cancel?",style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                  ),
                                  onPressed: ()=>{
                                    cancelOrder(),
                                    Navigator.pop(context)
                                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage())),
                                    // login()
                                  },
                                  child: Text("Yes",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),)
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                  ),

                                  onPressed: ()=>{
                                    Navigator.pop(context)
                                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage())),
                                    // login()
                                  },
                                  child: Text("No",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),)
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                ),
              ),
              Positioned(
                  top:-35,

                  child: CircleAvatar(
                    child: Icon(Icons.cancel,size: 40,),
                    radius: 40,

                  )),

            ],
          ),
        ),

      );
  Future openDiaolgForExit(BuildContext context,String id) =>
      showDialog(
        barrierColor: Colors.black38,

        context: context,

        builder: (context) => Dialog(
          backgroundColor: Colors.indigo.shade50,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  // height:600,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
                    child: Column(
                      children: [
                                Padding(
                                  padding: const EdgeInsets.only(top:20.0),
                                  child: Text("Are you sure want to cancel?",style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                        Padding(
                          padding: const EdgeInsets.only(top:20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                  ),
                                  onPressed: ()=>{
                                    cancelDetail(id),
                                    Navigator.pop(context)
                                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage())),
                                    // login()
                                  },
                                  child: Text("Yes",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),)
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                  ),

                                  onPressed: ()=>{
                                    Navigator.pop(context)
                                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage())),
                                    // login()
                                  },
                                  child: Text("No",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),)
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                ),
              ),
              Positioned(
                  top:-35,

                  child: CircleAvatar(
                    child: Icon(Icons.cancel,size: 40,),
                    radius: 40,

                  )),

            ],
          ),
        ),

      );
}
