import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Books> bookDetails = [];
  List bookdata = [];

  Future<List<Books>> _bookDetails() async {
    var data =
        await http.get('https://my.api.mockaroo.com/books.json?key=59b6aa70');
    var jsonData = jsonDecode(data.body);

    for (var bookval in jsonData) {
      Books books = Books(
        bookval['bookname'],
        bookval['bookauthor'],
        bookval['bookcover'],
        bookval['bookrating'],
        bookval['bookviews'],
      );
      bookDetails.add(books);
    }
    return bookDetails;
  }

  void _showModalSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            child: Text('Hello From Modal Bottom Sheet'),
            padding: EdgeInsets.all(40.0),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text('show'),
                  onPressed: _showModalSheet,
                ),
                FutureBuilder(
                  future: _bookDetails(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {

                    if (snapshot.data != null) {
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Card(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                            snapshot.data[index].bookname,
                                          ),
                                        RawMaterialButton(
                                            child: Icon(
                                         Icons.check,
                                         color: Colors.green,
                                            ),
                                            onPressed: () {
                                         print('id: $index');
                                            },
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );

                    } else {

                      return Center(
                        child: Container(
                          child: Text(
                            'Loading...',
                          ),
                        ),
                      );

                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// model books
class Books {
  final String bookname;
  final String bookauthor;
  final String bookcover;
  final int bookrating;
  final int bookviews;

  Books(this.bookname, this.bookauthor, this.bookcover, this.bookrating,
      this.bookviews);
}
