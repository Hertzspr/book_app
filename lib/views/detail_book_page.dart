import 'dart:convert';

import 'package:book_app_2_offline/models/book_detail_response.dart';
import 'package:book_app_2_offline/models/book_list_response.dart';
import 'package:book_app_2_offline/views/image_view_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailBookPage extends StatefulWidget {
  const DetailBookPage({
    Key? key,
    required this.isbn,
  }) : super(key: key);
  final String isbn;

  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  BookDetailResponse? detailBook;
  fetchDetailBookApi() async {
    print(widget.isbn);
    var url = Uri.parse('https://api.itbook.store/1.0/books/${widget.isbn}');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if(response.statusCode == 200) {
      final jsonDetail = jsonDecode(response.body);
      detailBook = BookDetailResponse.fromJson(jsonDetail);
      setState(() {});
      fetchSimilarBookApi(detailBook!.title!);
    }

    // print(await http.read(Uri.https('example.com', 'foobar.txt')));
  }

  BookListResponse? similarBooks;
  fetchSimilarBookApi(String title) async {
    print(widget.isbn);
    var url = Uri.parse('https://api.itbook.store/1.0/search/${title}');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if(response.statusCode == 200) {
      final jsonDetail = jsonDecode(response.body);
      similarBooks = BookListResponse.fromJson(jsonDetail);
      setState(() {});
    }

    // print(await http.read(Uri.https('example.com', 'foobar.txt')));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDetailBookApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: detailBook == null
          ?
      Center(child: CircularProgressIndicator())
          :
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Expanded(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImageViewScreen(imageUrl: detailBook!.image!),
                        ),
                      );
                    },
                    child: Image.network(detailBook!.image!,
                    height: 160
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 5.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(detailBook!.title!,
                            style:
                            TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(detailBook!.authors!,
                            style:
                            TextStyle(
                              fontSize: 10,
                            ),
                          ),
                          SizedBox(height: 15,),
                          Text(detailBook!.subtitle!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Row(
                            children:
                              List.generate(
                                5, (index) => Icon(Icons.star,
                                color: index < int.parse(detailBook!.rating!)
                                    ? Colors.green // if index less than rate
                                    : Colors.grey, // if index is equal or more than rate
                            ),
                            ),
                          ),
                          Text(detailBook!.price!,
                            style:
                            TextStyle(
                              fontSize: 13,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ],
                ),
              SizedBox(height: 5,),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  //style: ElevatedButton,
                  onPressed: () async {
                    print('url');
                    Uri uri = Uri.parse(detailBook!.url!);
                    try {
                      !await launchUrl(uri);
                    } catch (e) {
                      print('error');
                      print(e);
                    }
                  },
                  child: Text('Buy'),
                ),
              ),
              SizedBox(height: 10,),
              Text(detailBook!.desc!,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //Text(detailBook!.isbn10!),
                  Text('Year: ' + detailBook!.year!,
                  ),
                  Text('ISBN: ' + detailBook!.isbn13!,
                  ),
                  Text(detailBook!.pages! + 'Pages',
                  ),
                  Text('Publisher: ' + detailBook!.publisher!,
                  ),
                  Text('Language: ' + detailBook!.language!,
                  ),
                ],
              ),
              Divider(
                height: 40,
                thickness: 5,
              ),
              similarBooks == null
              ? CircularProgressIndicator()
              : Expanded(
                child: Container(
                  height: 150,
                  child: ListView.builder(
                    // shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: similarBooks!.books!.length,
                    // physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index){
                      final current = similarBooks!.books![index];
                      return Container(
                        width: 80,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: Column(    
                          children: [
                            Expanded(
                              child: Image.network(current.image!,
                              ),
                            ),
                            Expanded(child: Text(current.title!,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 9,
                            ),
                            ))
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              ],
            ),
        ),
      ),
    );
  }
}
