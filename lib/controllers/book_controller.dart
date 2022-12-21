

import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/book_detail_response.dart';
import '../models/book_list_response.dart';

import 'package:http/http.dart' as http;

class BookController extends ChangeNotifier{

  // For book_list_page
  BookListResponse? bookList;
  fetchBookApi() async {
    // copied from http documentation:
    var url = Uri.parse('https://api.itbook.store/1.0/new');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if(response.statusCode == 200) {
      final jsonBookList = jsonDecode(response.body);
      bookList = BookListResponse.fromJson(jsonBookList);
      notifyListeners();
    }

    // print(await http.read(Uri.https('example.com', 'foobar.txt')));
  }

  // For detail_book_page
  BookDetailResponse? detailBook;
  fetchDetailBookApi(isbn) async {
    //print(isbn);
    var url = Uri.parse('https://api.itbook.store/1.0/books/$isbn');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if(response.statusCode == 200) {
      final jsonDetail = jsonDecode(response.body);
      detailBook = BookDetailResponse.fromJson(jsonDetail);
      notifyListeners();
      fetchSimilarBookApi(detailBook!.title!);
    }

    // print(await http.read(Uri.https('example.com', 'foobar.txt')));
  }

  BookListResponse? similarBooks;
  fetchSimilarBookApi(String title) async {
    //print(widget.isbn);
    var url = Uri.parse('https://api.itbook.store/1.0/search/${title}');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if(response.statusCode == 200) {
      final jsonDetail = jsonDecode(response.body);
      similarBooks = BookListResponse.fromJson(jsonDetail);
      notifyListeners();
    }

    // print(await http.read(Uri.https('example.com', 'foobar.txt')));
  }


}