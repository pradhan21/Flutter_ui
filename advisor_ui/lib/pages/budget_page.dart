import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:advisor_ui/json/budget_json.dart';
import 'package:advisor_ui/json/day_month.dart';
import 'package:advisor_ui/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:velocity_x/velocity_x.dart';

import '../api_data/limitdata.dart';

class BudgetPage extends StatefulWidget {
  final String accessToken;
  BudgetPage({required this.accessToken});
  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> with TickerProviderStateMixin {
  late final TabController _maintabController;
  int activeDay = 3;
  TextEditingController _amountController = TextEditingController();
  FocusNode amountFocusNode = FocusNode();
  List<categorydata> categoriesdata = [];
  List<overalldata> overalldatas = [];
  List<categorylimit> categorylimits = [];
  List<overalllimit> overalllimits = [];

  @override
  void initState() {
    super.initState();
    amountFocusNode.addListener;
    fetchdata(widget.accessToken);

    _maintabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  void dispose() {
    amountFocusNode.removeListener;
    _maintabController.dispose();
    super.dispose();
  }

  Future<List<dynamic>> fetchdata(String accessToken) async {
    final url = 'http://10.0.2.2:8000/limit/limit/';

    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final categoriesData = jsonData;
      print(categoriesData);
      List<categorydata> categoriesdata = [];
      List<categorylimit> categorylimits = [];
      List<overalllimit> overalllimits = [];

      for (var categoryData in categoriesData) {
        final overallLimit = categoryData['overall_limit']?.toDouble() ?? 0.0;
        final expensesCategory = categoryData['expenses_Category'];
        final categoryLimit = categoryData['category_limit']?.toDouble() ?? 0.0;

        if (overallLimit != 0 && expensesCategory == null) {
          overalllimits.add(overalllimit.fromJson(categoryData));
        } else if (overallLimit == 0 && expensesCategory != null) {
          categorylimits.add(categorylimit.fromJson(categoryData));
        } else {
          categoriesdata.add(categorydata.fromJson(categoryData));
        }
      }

      // Print the categories data
      for (var data in categoriesdata) {
        print('Category Name: ${data.category_name}');
        print('Category Limit: ${data.category_limit}');
        print('Category Total: ${data.category_total}');
        print('------------------------');
      }

      // Print the category limits data
      for (var data in categorylimits) {
        print('Category Name: ${data.category_name}');
        print('Category Limit: ${data.category_limit}');
        print('------------------------');
      }

      // Print the overall limits data
      for (var data in overalllimits) {
        print('Overall Limit: ${data.overall_limit}');
        print('------------------------');
      }

      return [categoriesdata, categorylimits, overalllimits];
    } else {
      throw Exception(
          'Failed to fetch categories data. Status code: ${response.statusCode}');
    }
  }

  Future<void> updateCategorydata(int cat_id, double amount) async {
    final url = 'http://10.0.2.2:8000/limit/limit/$cat_id/';

    final response = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${widget.accessToken}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'category_limit': amount}),
    );

    if (response.statusCode == 200) {
      // Category data updated successfully
      print('Category data updated');
    } else {
      // Error updating category data
      print(
          'Failed to update category data. Status code: ${response.statusCode}');
    }
  }

  Future<void> deletecategorydata(int cat_id) async {
    final url = 'http://10.0.2.2:8000/limit/limit/$cat_id/';

    // Remove the deleted item from the local list

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${widget.accessToken}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Category data deleted successfully
      print('Category data deleted');
      setState(() {
        categorylimits.removeWhere((item) => item.cat_id == cat_id);
      });
    } else {
      // Error deleting category data
      print(
          'Failed to delete category data. Status code: ${response.statusCode}');

      // If deletion fails, add the item back to the local list
    }
  }

  Future<void> updateoveralldata(int cat_id, double amount) async {
    final url = 'http://10.0.2.2:8000/limit/limit/$cat_id/';

    final response = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${widget.accessToken}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'overall_limit': amount}),
    );

    if (response.statusCode == 200) {
      // Category data updated successfully
      print('Category data updated');
    } else {
      // Error updating category data
      print(
          'Failed to update category data. Status code: ${response.statusCode}');
    }
  }

  Future<void> deleteoveralldata(int cat_id) async {
    final url = 'http://10.0.2.2:8000/limit/limit/$cat_id/';

    // Remove the deleted item from the local list

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${widget.accessToken} ',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Category data deleted successfully
      print('Category data deleted');
      setState(() {
        overalllimits.removeWhere((item) => item.cat_id == cat_id);
      });
    } else {
      // Error deleting category data
      print(
          'Failed to delete category data. Status code: ${response.statusCode}');

      // If deletion fails, add the item back to the local list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: getBody(),
    );
  }

  Widget getBody() {
    return FutureBuilder<List<dynamic>>(
      future: fetchdata(widget.accessToken),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<dynamic> data = snapshot.data!;
          List<categorydata> categoriesdata = data[0];
          List<categorylimit> categorylimits = data[1];
          List<overalllimit> overalllimits = data[2];
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 50,
                  right: 20,
                  left: 20,
                  bottom: 0,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 20),
                        Text(
                          "Budget",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: tabbody(categorylimits, overalllimits),
              ),
            ],
          );
        }
      },
    );
  }

  Widget tabbody(
    List<categorylimit> categorylimits,
    List<overalllimit> overalllimits,
  ) {
    var size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            PreferredSize(
              preferredSize: Size.fromHeight(30),
              child: TabBar(
                indicatorColor: Colors.black,
                tabs: <Widget>[
                  Tab(
                    text: 'Custom Budget',
                    icon: Icon(Icons.speed_rounded),
                  ),
                  Tab(
                    text: 'Overall Budget',
                    icon: Icon(Icons.wallet),
                  ),
                ],
                controller: _maintabController,
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _maintabController,
                children: [
                  Container(
                    color: Color.fromARGB(255, 233, 227, 227),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 35),
                      child: ListView.builder(
                        itemCount: categorylimits.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              editCategoryPopup(context, categorylimits[index]);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: grey.withOpacity(0.01),
                                      spreadRadius: 10,
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 25, right: 25, bottom: 25, top: 25),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        categorylimits[index].category_name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: Color(0xff67727d)
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                categorylimits[index]
                                                    .category_limit
                                                    .toDouble()
                                                    .toStringAsFixed(2),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 3),
                                            child: Text(
                                              categorylimits[index]
                                                  .category_limit
                                                  .toDouble()
                                                  .toStringAsFixed(2),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13,
                                                color: Color(0xff67727d)
                                                    .withOpacity(0.6),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    color: Color.fromARGB(255, 233, 227, 227),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 35),
                      child: ListView.builder(
                        itemCount: overalllimits.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              editOverallPopup(context, overalllimits[index]);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: grey.withOpacity(0.01),
                                      spreadRadius: 10,
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 25, right: 25, bottom: 25, top: 25),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Overall Budget",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: Color(0xff67727d)
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                overalllimits[index]
                                                    .overall_limit
                                                    .toDouble()
                                                    .toStringAsFixed(2),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 3),
                                            child: Text(
                                              overalllimits[index]
                                                  .overall_limit
                                                  .toDouble()
                                                  .toStringAsFixed(2),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13,
                                                color: Color(0xff67727d)
                                                    .withOpacity(0.6),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> editCategoryPopup(
      BuildContext context, categorylimit category) async {
    final TextEditingController _amountController = TextEditingController(
      text: category.category_limit.toDouble().toStringAsFixed(2),
    );
    double editedTotal = category.category_limit.toDouble();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                category.category_name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                    ),
                    onChanged: (value) {
                      setState(() {
                        editedTotal = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: button),
                      onPressed: () async {
                        await updateCategorydata(category.cat_id, editedTotal);
                        Navigator.pop(context); // Close the popup
                      },
                      child: Text('Update'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: button),
                      onPressed: () {
                        deletecategorydata(category.cat_id);
                        Navigator.pop(context); // Close the popup
                      },
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> editOverallPopup(
      BuildContext context, overalllimit overall) async {
    final TextEditingController _amountController = TextEditingController(
      text: overall.overall_limit.toDouble().toStringAsFixed(2),
    );
    double editedTotal = overall.overall_limit.toDouble();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                'Overall Budget',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                    ),
                    onChanged: (value) {
                      setState(() {
                        editedTotal = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: button),
                      onPressed: () {
                        updateoveralldata(overall.cat_id, editedTotal);
                        Navigator.pop(context); // Close the popup
                      },
                      child: Text('Update'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: button),
                      onPressed: () {
                        deleteoveralldata(overall.cat_id);
                        Navigator.pop(context); // Close the popup
                      },
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
