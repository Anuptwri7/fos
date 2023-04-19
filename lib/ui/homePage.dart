import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fos/ui/takeOrderPage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../consts/methods_const.dart';
import '../consts/string_const.dart';
import '../consts/style_const.dart';
import '../models/getTableList.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isVacant = true;
  bool isOccupied = false;
  bool isReserved = false;

    Future<void> _refresh(){
      return getTableList();

    }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: ()=>popAndLoadPage(),
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              InkWell(
                onTap: () {},
                child: Stack(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.logout,
                        color: Color(0xffBF1E2E),
                        size: 30,
                      ),
                      onPressed: () async {},
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 15,
              ),
            ],
            title: Row(
              children: [],
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            color: Colors.green.shade300,
                          ),
                          SizedBox(width: 10,),
                          Text("VACANT")
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 10,),
                          Text("SERVED")
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            color: Colors.red,
                          ),
                          SizedBox(width: 10,),
                          Text("OCCUPIED")
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            color: Colors.yellow,
                          ),
                          SizedBox(width: 10,),
                          Text("RESERVED")
                        ],
                      ),
                    ],
                  ),
                ),
                FutureBuilder<List<Results>?>(
                    future: getTableList(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator());
                        default:
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return _getTableList(snapshot.data);
                          }
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
  _getTableList(List<Results>? data) {
    return data != null
        ? ListView.builder(
        shrinkWrap: true,
        itemCount: 1,
        // physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top:20.0),
            child: Card(
              margin: kMarginPaddSmall,
              color: Colors.white,
              elevation: kCardElevation,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              child: GridView.count(
                crossAxisCount: 4,
                scrollDirection: Axis.vertical,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                shrinkWrap: true,
                children: List.generate(
                  data.length,
                      (index) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: GestureDetector(
                        onTap: (){
                          // final snackBar = SnackBar(
                          //   behavior: SnackBarBehavior.floating,
                          //   margin: EdgeInsets.only(bottom: 500.0),
                          //   content: const Text('Table yet not billed'),
                          //   backgroundColor: (Colors.black12),
                          //   action: SnackBarAction(
                          //     label: 'dismiss',
                          //     onPressed: () {
                          //     },
                          //   ),
                          // );
                          // data[index].status==3?
                          // ScaffoldMessenger.of(context).showSnackBar(snackBar)
                          //     :
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>TakeOrderPage(tableName: data[index].name,tableNo: data[index].id.toString(),status: data[index].status,)));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: data[index].status==0?Colors.red.shade300:data[index].status==1?Colors.green.shade300:data[index].status==3?Colors.blue.shade300:Colors.yellow.shade300,
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                          ),
                          child: Center(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.chair),
                              Text("${data[index].name}"),
                            ],
                          )),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        })
        : Center(
      child: Text(
     '',
        style: kTextStyleBlack,
      ),
    );
  }
  popAndLoadPage() {
    Navigator.pop(context);
    Navigator.pop(context);
    goToPage(context,HomePage());

    // goToPage(context, PickUpDetails());
  }
  Future<List<Results>?> getTableList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String finalUrl = prefs.getString("subDomain").toString();

    final response = await http.get(
        Uri.parse('${StringConst.mainUrl}${StringConst.getTableList}?ordering=id'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });
log(response.body);
    if (response.statusCode == 401) {
    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return getTableListFromJson(response.body.toString()).results;
      } else {

      }
    }

    return null;
  }
}

