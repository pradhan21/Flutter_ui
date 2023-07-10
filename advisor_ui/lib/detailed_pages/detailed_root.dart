import 'dart:convert';

import 'package:advisor_ui/theme/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:advisor_ui/detailed_data/dailyexpense.dart';

class DetailedRoot extends StatefulWidget {
  final String accessToken;
final List<double> dataPoints = [20, 30, 50];
  DetailedRoot({required this.accessToken});

  @override
  _DetailedRootState createState() => _DetailedRootState();
}

class _DetailedRootState extends State<DetailedRoot>
    with TickerProviderStateMixin {
  late final TabController _maintabController;

  
  

  @override
  void initState() {
    super.initState();
    _maintabController = TabController(length: 3, vsync: this, initialIndex: 1);
    
  }

  @override
  void dispose() {
    _maintabController.dispose();
    super.dispose();
  }

  

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Primary and Secondary TabBar'),
        bottom: TabBar(
          indicatorColor: Colors.white,
          tabs: const <Widget>[
            Tab(
              text: 'Incomes',
              icon: Icon(Icons.download_for_offline_rounded),
            ),
            Tab(
              text: 'Expenses',
              icon: Icon(Icons.file_upload_outlined),
            ),
            Tab(
              text: 'Budget',
              icon: Icon(Icons.account_balance_wallet),
            ),
          ],
          controller: _maintabController,
        ),
      ),
      body: TabBarView(
        controller: _maintabController,
        children: [
          NestedTabBar(
            outerTab: 'Incomes',
            accessToken:widget.accessToken,
          ),
          NestedTabBar(
            outerTab: 'Expenses',
            accessToken: widget.accessToken,
          ),
          NestedTabBar(
            outerTab: 'Budget',
            accessToken: widget.accessToken,
          ),
        ],
      ),
    );
  }
}

class NestedTabBar extends StatefulWidget {
  final String outerTab;
  final List<expense> expenseData;
  final String accessToken;
 
  NestedTabBar({required this.outerTab,this.expenseData = const [],required this.accessToken});
 final List<double> dataPoints = [20, 30, 50];
  @override
  _NestedTabBarState createState() => _NestedTabBarState();
}

class _NestedTabBarState extends State<NestedTabBar> with TickerProviderStateMixin {
  late final TabController _tabController;
  // List<expense> _expenseData = [];
  List<PieChartSectionData>? sections = [];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    fetchMonthExpenseData(widget.accessToken);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Future<void> _fetchMonthlyExpenseData() async {
  //   try {
  //     final List<expense> data = await fetchMonthExpenseData(widget.accessToken);
  //     setState(() {
  //       _expenseData = data;
  //     });
  //   } catch (e) {
  //     print('Error fetching expense data: $e');
  //   }
  // }
// Future<List<expense>> fetchMonthExpenseData(String accessToken) async {
//   try {
//     final url = "http://127.0.0.1:8000/core/expenses-category-month/";
//     final response = await http.get(Uri.parse(url), headers: {
//       'Authorization': 'Bearer $accessToken',
//     });

//     if (response.statusCode == 200) {
//       final dynamic responseData = json.decode(response.body);
//       if (responseData != null && responseData['filtered'] != null) {
//         final dynamic filteredData = responseData['filtered'];
//             print('expenses_____+$filteredData');
//         if (filteredData != null) {
//           double amount = 0;
//           List<expense> expenses = [];

//           for (var categoryData in filteredData) {
//             final incomeItem = expense.fromJson(categoryData);
//             amount = incomeItem.amount;
//             expenses.add(incomeItem);
//           }

//           final expenseData = PieChartSectionData(
//             value: amount.toDouble(),
//             color: Colors.blue,
//             title: 'Monthly Expense',
//             radius: 100,
//           );

//           setState(() {
//             sections = [expenseData];
//           });

//           return expenses;
//         }
//       }
//     }

//     throw Exception('Failed to fetch expense data');
//   } catch (e) {
//     print("error fetching monthly expense data: $e");
//     throw Exception('Failed to fetch expense data: $e');
//   }
// }

Future<List<expense>> fetchMonthExpenseData(String accessToken) async {
  try {
    final url = "http://10.0.2.2:8000/core/expenses-category-month/";
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      final dynamic responseData = json.decode(response.body);
      if (responseData != null && responseData['filtered'] != null) {
        final dynamic filteredData = responseData['filtered'];
        print('expenses_____+$filteredData');
        if (filteredData != null) {
          List<PieChartSectionData> sections = [];
          double totalAmount = 0;
          List<expense> expenses = [];

          for (var categoryData in filteredData) {
            final incomeItem = expense.fromJson(categoryData);
            totalAmount += incomeItem.amount;
            expenses.add(incomeItem);

            final section = PieChartSectionData(
              value: incomeItem.amount.toDouble(),
              color: Colors.blue,
              title: '${incomeItem.category}',
              radius: 100,
            );
            sections.add(section);
          }

          final expenseData = PieChartSectionData(
            value: totalAmount.toDouble(),
            color: Colors.blue,
            title: 'Monthly Expense',
            radius: 100,
          );

          setState(() {
            this.sections = sections;
          });

          return expenses;
        }
      }
    }

    throw Exception('Failed to fetch expense data');
  } catch (e) {
    print("error fetching monthly expense data: $e");
    throw Exception('Failed to fetch expense data: $e');
  }
}



  Widget buildIncomeOverview() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
        
        width: 590,
        height: 490,
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: grey.withOpacity(0.01),
              spreadRadius: 50,
              blurRadius: 3,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Net Income',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: Color(0xff67727d),
                      ),
                    ),
                    SizedBox(height: 8),
                    // Add any other income-related widgets here
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child:GestureDetector(
                  onTap:(){},
                  child: Container(
                  width: 340,
                  height: 350,
                  
                  child: PieChart(
                    PieChartData(
                      sections:sections,
                      centerSpaceRadius: 60,
                      
                      // size: Size(300, 300),
                    ),
                  ),
                ),)
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar(
          labelColor: green,
          indicatorColor: green,
          unselectedLabelColor: black,
          
          controller: _tabController,
          tabs: const <Widget>[
            Tab(text: 'Overview'),
            Tab(text: 'Specifications'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              // Overview Tab
              Card(
                child:Center(
                  
             child: widget.outerTab == 'Incomes'
                  ? buildIncomeOverview()
                  : Container(),
              )),
              // Specifications Tab
              Card(
                margin: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text('${widget.outerTab}: Specifications tab'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
