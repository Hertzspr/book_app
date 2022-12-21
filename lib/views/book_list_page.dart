import 'package:book_app_2_offline/controllers/book_controller.dart';
import 'package:book_app_2_offline/views/detail_book_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class BookListPage extends StatefulWidget {
  const BookListPage({Key? key}) : super(key: key);

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {

  // Create bookController object from BookController class
  BookController? bookController;

  @override
  // TODO: implement initState
  void initState() {
    super.initState();
    bookController = Provider.of<BookController>(context, listen: false);
    bookController!.fetchBookApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Catalogue'),
      ),
      body: Consumer<BookController>(
        child: Center(child: CircularProgressIndicator()),
        builder:(context, controller, child) => Container(
          child: bookController!.bookList == null
              ? child
              : ListView.builder(
                  itemCount: bookController!.bookList!.books!.length,
                    itemBuilder: (context, index){
                      final currentBook = bookController!.bookList!.books![index];
                  return GestureDetector(
              onTap: (){
                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailBookPage(
                            isbn: currentBook.isbn13!,
                          ),
                    ),
                );
              },
              child: Row(
                  children: [
                    Image.network(currentBook.image!,
                    height: 100,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(currentBook.title!,
                            ),
                            Text(currentBook.subtitle!,
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(currentBook.price!,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )

                  ],
                  ),
            );

          }),
        ),
      ),
    );
  }
}
