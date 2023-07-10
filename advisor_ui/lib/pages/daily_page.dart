import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:advisor_ui/api_data/dailpagedata.dart';
import 'package:advisor_ui/json/daily_json.dart';
import 'package:advisor_ui/json/day_month.dart';
import 'package:advisor_ui/theme/colors.dart';
import 'package:flutter/material.dart';
import "package:flutter_vector_icons/flutter_vector_icons.dart";
import 'package:intl/intl.dart'; 

class DailyPage extends StatefulWidget {
final String accessToken;
  DailyPage({required this.accessToken});
  
  @override
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> with TickerProviderStateMixin{
  Timer? timer;
  DateTime currentDate = DateTime.now(); // Get the current date
List<DateTime> visibleDates = [];
List<income> incomes = [];
List<expense> expenses = [];
List<Category> categories = [];
List<ExpCategory> expcategories = [];

 void initState() {
    super.initState();
    for (int i = 0; i < 7; i++) {
      DateTime date = currentDate.add(Duration(days: i));
      visibleDates.add(date);
    }
  //   Timer.periodic(Duration(seconds: 1), (_) {  fetchExpenses();
  // fetchIncomes();
  //     fetchCategories(widget.accessToken);
  //    fetchexpCategories(widget.accessToken);});
    fetchExpenses();
    fetchIncomes();
    fetchCategories(widget.accessToken);
  }
  int activeDay = 1;

    void goToPreviousDates() {
    setState(() {
      currentDate = currentDate.subtract(Duration(days: 1));
    });
  }

  void goToFutureDates() {
    setState(() {
      currentDate = currentDate.add(Duration(days: 1));
    });
  }

  void updateVisibleDates() {
    visibleDates.clear();
    for (int i = 0; i < 7; i++) {
      DateTime date = currentDate.add(Duration(days: i));
      visibleDates.add(date);
    }
  }

@override
void dispose() {
  timer?.cancel(); // Cancel any active timers
  super.dispose();
}


  Future<void> fetchIncomes() async {
    try {
      List<income> fetchedIncomes = await fetchIncome(widget.accessToken);
      print( fetchedIncomes);
      setState(() {
        incomes = fetchedIncomes;
      });
    } catch (error) {
      print('Error fetching incomes: $error');
    }
  }

  Future<List<income>> fetchIncome(String accessToken) async {
    final url = 'http://127.0.0.1:8000/income/income/';

    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final incomesData = jsonData['results'];
      List<income> fetchedIncomes = [];

      if (incomesData != null) {
        for (var incomeData in incomesData) {
          fetchedIncomes.add(income.fromJson(incomeData));
        }
      }
      return fetchedIncomes;
    } else {
      throw Exception(
          'Failed to fetch incomes. Status code: ${response.statusCode}');
    }
  }

  Future<void> fetchExpenses() async {
    try {
      List<expense> fetchedExpenses = await fetchExpense(widget.accessToken);
      setState(() {
        expenses = fetchedExpenses;
      });
    } catch (error) {
      print('Error fetching expenses: $error');
    }
  }

  Future<List<expense>> fetchExpense(String accessToken) async {
    final url = 'http://127.0.0.1:8000/expenses/expenses/';

    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final expensesData = jsonData['results'];
      print(jsonData);
      List<expense> expenses = [];
      if (expensesData != null) {
        for (var expenseData in expensesData) {
          expenses.add(expense.fromJson(expenseData));
        }
      }
      return expenses;
    } else {
      print("error");
      throw Exception(
          'Failed to fetch expenses. Status code: ${response.statusCode}');
    }
  }

  Future<List<Category>> fetchCategories(String accessToken) async {
    final url = 'http://127.0.0.1:8000/incomeCat/incomecategory/';

    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final categoriesData = jsonData['filtered'];
      List<Category> fetchedCategories = [];

      for (var categoryData in categoriesData) {
        fetchedCategories.add(Category.fromJson(categoryData));
      }

      setState(() {
        categories = fetchedCategories;
      });

      return fetchedCategories;
    } else {
      throw Exception(
          'Failed to fetch categories. Status code: ${response.statusCode}');
    }
  }

    Future<List<ExpCategory>> fetchexpCategories(String accessToken) async {
    final url = 'http://127.0.0.1:8000/expensesCat/excategory/';

    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final categoriesData = jsonData['filtered'];
      // print("Expenses Categories:__________" + categoriesData.toString());
      List<ExpCategory> expcategories = [];

      for (var categoryData in categoriesData) {
        expcategories.add(ExpCategory.fromJson(categoryData));
        
      }

      return expcategories;
    } else {
      throw Exception(
          'Failed to fetch categories. Status code: ${response.statusCode}');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color.fromARGB(255, 233, 227, 227),
      body: getBody(),
    );
  }

  Widget getBody() {
    // print("daily_page_accessToken__________" + widget.accessToken);
    var size = MediaQuery.of(context).size;
    List<income> filteredIncomes = incomes.where((income) {
    DateTime incomeDate = DateTime.parse(income.date);
    return incomeDate.year == currentDate.year &&
        incomeDate.month == currentDate.month &&
        incomeDate.day == currentDate.day;
  }).toList();
 List<expense> FilteredExpenses = expenses.where((expense) {
  try {
    DateTime expenseDate = DateFormat('yyyy-MM-dd').parse(expense.date);
    return expenseDate.year == currentDate.year &&
        expenseDate.month == currentDate.month &&
        expenseDate.day == currentDate.day;
  } catch (e) {
    print('Error parsing date: $e');
    return false; // Exclude the expense if the date parsing fails
  }
}).toList();
print(FilteredExpenses);

  double calculateTotalAmount(List<income> filteredIncomes) {
  double total = 0;
  for (var income in filteredIncomes) {
    total += income.amount;
  }
  return total;
}
String getCategoryIconUrl(int categoryId, List<Category> categories) {
  final category = categories.firstWhere((c) => c.id == categoryId, orElse: () => Category(id: 0, name: '', iconUrl: ''));
  return category.iconUrl;
}
String getexpCategoryIconUrl(int categoryId, List<ExpCategory> expcategories) {
  final category = expcategories.firstWhere((c) => c.id == categoryId, orElse: () => ExpCategory(id: 0, name: '', iconUrl: ''));
  return category.iconUrl;
}

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: white, boxShadow: [
              BoxShadow(
                color: grey.withOpacity(0.01),
                spreadRadius: 10,
                blurRadius: 3,
                // changes position of shadow
              ),
            ]),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 30, right: 20, left: 20, bottom: 25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  Text(
                  "Daily Transaction",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: black,
                  ),
                ),Icon(AntDesign.search1)
                    ],
                  ),
                const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      
                      IconButton(
                  onPressed: goToPreviousDates,
                  icon: Icon(Icons.arrow_back),
                ),
                Text(
                   DateFormat('EEE, MMM d, y').format(currentDate),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: black,
                  ),
                ),
                IconButton(
                  onPressed: goToFutureDates,
                  icon: Icon(Icons.arrow_forward),
                ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(visibleDates.length, (index) {
                      final DateFormat dayFormat = DateFormat('EEE'); // Format the day abbreviation
                      final DateFormat dateFormat = DateFormat('dd'); // Format the day of the month

                       DateTime date = visibleDates[index];
                        bool isCurrentDate = date.day == currentDate.day &&
                            date.month == currentDate.month &&
                            date.year == currentDate.year;
                      // Set the index of the current date

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            String currentDate = DateFormat('y-M-d').format(date);
                            print(currentDate);
                            activeDay = index;
                          });
                        },
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 40) / 7,
                          child: Column(
                            children: [
                              Text(
                                dayFormat.format(visibleDates[index]), // Display the day abbreviation
                                style: TextStyle(fontSize: 10),
                              ),
                              SizedBox(height: 10),
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: isCurrentDate ? Colors.red : Colors.transparent, // Highlight current date in red color
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: activeDay == index
                                        ? primary
                                        : black.withOpacity(0.1),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    dateFormat.format(visibleDates[index]), // Display the day of the month
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      // color: activeDay == index ? white : black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  )

                ],
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
         
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
                children: List.generate(filteredIncomes.length, (index) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: (size.width - 40) * 0.7,
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: grey.withOpacity(0.1),
                              ),
                              child: Center(
                                child: Image.network(
                                    getCategoryIconUrl(filteredIncomes[index].category_id, categories),
                                    color:black,
                                    width: 30,
                                    height: 30,
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Container(
                              width: (size.width - 90) * 0.5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    filteredIncomes[index].category_name,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: black,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                     filteredIncomes[index].note,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: black.withOpacity(0.5),
                                        fontWeight: FontWeight.w400),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: (size.width - 40) * 0.3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              filteredIncomes[index].amount.toStringAsFixed(2),
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.green),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 65, top: 8),
                    child: Divider(
                      thickness: 0.8,
                      color:black,
                    ),
                  )
                ],
              );
            })),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
                children: List.generate(FilteredExpenses.length, (index) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: (size.width - 40) * 0.7,
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: grey.withOpacity(0.1),
                              ),
                              child: Center(
                                child: Image.network(
                                    getexpCategoryIconUrl(FilteredExpenses[index].category_id, expcategories),
                                    color:black,
                                    width: 30,
                                    height: 30,
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Container(
                              width: (size.width - 90) * 0.5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    FilteredExpenses[index].category_name,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: black,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                     FilteredExpenses[index].note,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: black.withOpacity(0.5),
                                        fontWeight: FontWeight.w400),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: (size.width - 40) * 0.3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              FilteredExpenses[index].amount.toStringAsFixed(2),
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.red),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 65, top: 8),
                    child: Divider(
                      thickness: 0.8,
                      color:black,
                    ),
                  )
                ],
              );
            })),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 80),
                  child: Text(
                    "Total",
                    style: TextStyle(
                        fontSize: 16,
                        color: black.withOpacity(0.4),
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                   "\$${calculateTotalAmount(filteredIncomes).toStringAsFixed(2)}",
                    style: TextStyle(
                        fontSize: 20,
                        color: black,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
