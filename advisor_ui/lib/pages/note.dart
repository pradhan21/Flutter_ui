import 'dart:async';
import 'dart:convert';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:advisor_ui/theme/colors.dart';
import 'package:intl/intl.dart';
import '../api_data/notedata.dart';
import '../core/route/app_route_name.dart';
import 'package:intl/intl.dart';

class NotePage extends StatefulWidget {
  final String accessToken;
  NotePage({required this.accessToken});

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  List<notedata> notesdata = [];
   List<noteamount> notesamount = [];
  List<String> list = <String>['Payable', 'Receivable'];
   String dropdownValue = ' ';
TextEditingController _titleController = TextEditingController();
TextEditingController _amountController = TextEditingController();
TextEditingController _discController = TextEditingController();
TextEditingController dateController = TextEditingController();
late double totalPayable=0;
late double totalreceivable = 0;
  @override
  void initState() {
    super.initState();
    dropdownValue = list.first;
    fetchamount(widget.accessToken);
      fetchdata(widget.accessToken);
    // Timer.periodic(Duration(seconds: 1), (_) {  
    //   fetchamount(widget.accessToken);
    //   fetchdata(widget.accessToken);
    // });

  }

  Future<void> _createnote(String title, int amount, String desc, String type, String date ) async{
    final url = Uri.parse('http://10.0.2.2:8000/todo/todo/');
    final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${widget.accessToken}',
    // Add any required headers
  };
  print(widget.accessToken);
  final body = jsonEncode({
    'title': title,
    'amount': amount,
    'discription': desc,
    'type':type,
    'date': date,
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 201) {
    // Budget created successfully
    // You can perform any additional actions here
    print('NOte created successfully');
     showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('SuccessFully created Note '),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: button),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Close the previous dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    fetchdata(widget.accessToken);
  } else {
    // Failed to create budget
    // Handle the error accordingly
    print('Failed to create note. Status code: ${response.statusCode}');
  }
  }

Future<void> _updatenote(int id, title, int amount, String desc, String type, String date ) async{
    final url = Uri.parse('http://10.0.2.2:8000/todo/todo/$id/');
    final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${widget.accessToken}',
    // Add any required headers
  };
  // print(widget.accessToken);
  final body = jsonEncode({
    'title': title,
    'amount': amount,
    'discription': desc,
    'type':type,
    'date': date,
  });

  final response = await http.patch(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    // Budget created successfully
    // You can perform any additional actions here
    print('NOte updated successfully');
     showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('SuccessFully updated Note '),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: button),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Close the previous dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
   await fetchdata(widget.accessToken);
  } else {
    // Failed to create budget
    // Handle the error accordingly
    print('Failed to update note. Status code: ${response.statusCode}');
  }
  }

  Future<List<notedata>> fetchdata(String accessToken) async {
    final url = 'http://10.0.2.2:8000/todo/todo/';

    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final categoriesData = jsonData['results'];
      print(categoriesData);

      List<notedata> notesdata = [];
      for (var categoryData in categoriesData) {
        notesdata.add(notedata.fromJson(categoryData));
      }

      // Print the categories data
      setState(() {
        this.notesdata = notesdata;
      });
      return notesdata;
    } else {
      throw Exception(
          'Failed to fetch notes data. Status code: ${response.statusCode}');
    }
  }
  Future<List<noteamount>> fetchamount(String accessToken) async {
    final url = 'http://10.0.2.2:8000/todo/amount/';

    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final categoriesData = jsonData['data'];
      print(categoriesData);

      List<noteamount> notesamount = [];
      for (var categoryData in categoriesData) {
        notesamount.add(noteamount.fromJson(categoryData));
      }
      double totalPayable = 0;
        for (var item in notesamount) {
          totalPayable = item.pamount;
        }
        double totalreceivable = 0;
        for (var item in notesamount) {
          totalreceivable = item.ramount;
        }

      // Print the categories data
      setState(() {
        this.notesamount = notesamount;
      });
      return notesamount;
    } else {
      throw Exception(
          'Failed to fetch notes amount. Status code: ${response.statusCode}');
    }
  }

  Future<void> deleteoveralldata(int note_id) async {
  final url = 'http://10.0.2.2:8000/todo/todo/$note_id/';

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
    notesdata.removeWhere((item) => item.note_id == note_id);
  });
  await fetchdata(widget.accessToken);
  Navigator.pushNamed(context, AppRouteName.root, arguments: { 'accessToken': widget.accessToken,});
  } else {
    // Error deleting category data
    print('Failed to delete category data. Status code: ${response.statusCode}');

    // If deletion fails, add the item back to the local list
   
  }
}

  Color getTileColor(String type) {
    switch (type) {
      case 'receivable':
        return Colors.blue[700]!;
      case 'payable':
        return Colors.red;
      default:
        return Colors.grey; // Set a default color when the type is not recognizable
    }
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Color.fromARGB(255, 233, 227, 227),
    body: SingleChildScrollView(
      child: Column(
        children:[
          Container(
            color:black,
            height: 150,
            child:Padding(
            padding: EdgeInsets.only(top: 45, left: 15, right: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width:50),
                      Text(
                        "Notes",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(onPressed: (){}, icon: Icon(Icons.search,color: white,) ),                    
                    ],
                  ),
                ],
              )
            )
          ),
          Container(
            color:grey,
            height: 80,
            child:Padding(
                padding:EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:[
                    Column(
                      children: [
                        Text("Total Payable", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("RS ${totalPayable}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                      ],
                    ),
                    Column(
                      children: [
                        Text("Total Receivable", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("RS ${totalreceivable}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                      ],
                    )
                  ]
                ),
            ),
          ),
          Container(
          child:Padding(
          padding: EdgeInsets.only( left: 15, right: 15, bottom:10),
          child: Column(
            children: [
            // Add some spacing between the title and the list
            notesdata.isEmpty
                ? Center(
                    child: Text('No data found.'),
                  )
                : Padding(
  padding: EdgeInsets.symmetric(horizontal: 15),
  child: ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: notesdata.length,
    itemBuilder: (context, index) {
      final note = notesdata[index];
      final Color tileColor = getTileColor(note.type);

      return Padding( // Wrap each ListTile with Padding widget
        padding: EdgeInsets.symmetric(vertical: 8), // Set the vertical spacing
        child: Material(
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            child: ListTile(
              title:Row(
                mainAxisAlignment:MainAxisAlignment.spaceBetween, 
                  children:[
                    Text(note.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                     Text(note.amount.toStringAsFixed(2), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ]
              ),
              subtitle: Text(note.discription,style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
              tileColor: tileColor,
              onTap: () {
                // Custom page transition when tapping on the ListTile
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      // This is your details page
                      return Scaffold(
                        backgroundColor: Color.fromARGB(255, 233, 227, 227),
                        appBar: AppBar(
                          title: Text(note.title),
                          backgroundColor: Colors.black,
                        ),
                        body: Padding(
                          padding: EdgeInsets.only(top: 20, right: 10, left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                        Text("Amount:", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                                        Text(" ${note.amount.toStringAsFixed(2)}",style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal)),
                                        const SizedBox(height: 20,),
                                        Text("Discription:", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                                        Text("${note.discription}",style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal)),
                                        const SizedBox(height: 20,),
                                          Text("Due Date:", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                                        Text(" ${note.date}",style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal)),
                                        const SizedBox(height: 20,),
                                          Text("Created Date:", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                                        Text(" ${note.created_date}",style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal)),
                                        const SizedBox(height: 20,),
                                          Text("Type:", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                                        Text("Type: ${note.type}",style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal)),
                                        const SizedBox(height: 50,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(backgroundColor: button),
                                              onPressed: () async {
                                                _showeditPopup(context,  note);
                                                //  Navigator.of(context).pop();
                                              },
                                              child: Text('Edit Note'),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(backgroundColor: button),
                                              onPressed: () {
                                                deleteoveralldata(note.note_id);
                                                
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("Delete Note"),
                                            ),
                                          ],
                                        )
                                         ],
                                        ),
                                      ),
                                    );
                                  },
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    // Custom transition animation
                                    return FadeTransition(opacity: animation, child: child);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height:10),
          ],
        ),
      )),])
    ),

      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: button,
        overlayColor: Colors.black,
        overlayOpacity: 0.6,
        children: [
          SpeedDialChild(
            backgroundColor: button,
            child: Icon(Icons.add),
            label: 'Add Note',
            onTap: () {
              // Handle add expense action
               _showPopup(context);
            },
          )
        ],
      ),
    );
  }
   void _showPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Create Note'),
        content: SingleChildScrollView( // Add SingleChildScrollView here
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Amount'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _discController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Type",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  DropdownButton<String>(
                    value: list.first,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Select Date Of Birth",
                ),
                readOnly: true,
                style: Theme.of(context).textTheme.bodyMedium,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime(2100));
                  if (pickedDate != null) {
                    print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    print(
                        formattedDate); //formatted date output using intl package =>  2021-03-16
                    setState(() {
                      dateController.text =
                          formattedDate; //set output date to TextField value.
                    });
                  } else {}
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: button),
                    onPressed: () async {
                      final String title = _titleController.text;
                      final int amount = int.parse(_amountController.text);
                      final String disc = _discController.text;
                      final String type = dropdownValue.toLowerCase();
                      final String date = dateController.text;
                      print(title);
                      print(amount);
                      print(disc);
                      print(type);
                      print(date);
                      _createnote(title, amount, disc, type, date);
                      //  Navigator.of(context).pop();
                    },
                    child: Text('Create Note'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: button),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}


void _showeditPopup(BuildContext context, notedata note ) {
  _titleController.text= note.title;
  _amountController.text= note.amount.toStringAsFixed(0);
  _discController.text= note.discription;
  dropdownValue= note.type;
  dateController.text =note.date;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        
        title: Text('Create Note'),
        content: SingleChildScrollView( 
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Amount'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _discController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Type",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  DropdownButton<String>(
                    value: list.first,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Select Date Of Birth",
                ),
                readOnly: true,
                style: Theme.of(context).textTheme.bodyMedium,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime(2100));
                  if (pickedDate != null) {
                    print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    print(
                        formattedDate); //formatted date output using intl package =>  2021-03-16
                    setState(() {
                      dateController.text =
                          formattedDate; //set output date to TextField value.
                    });
                  } else {}
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: button),
                    onPressed: () async {
                      final String title = _titleController.text;
                      final int amount = int.parse(_amountController.text);
                      final String disc = _discController.text;
                      final String type = dropdownValue.toLowerCase();
                      final String date = dateController.text;
                      print(title);
                      print(amount);
                      print(disc);
                      print(type);
                      print(date);
                      _updatenote(note.note_id,title, amount, disc, type, date);
                      //  Navigator.of(context).pop();
                    },
                    child: Text('Create Note'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: button),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}

}
