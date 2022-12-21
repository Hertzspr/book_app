import 'package:book_app_2_offline/controllers/book_controller.dart';
import 'package:book_app_2_offline/views/image_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  BookController? detailController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    detailController = Provider.of<BookController>(context, listen: false);
    detailController!.fetchDetailBookApi(widget.isbn);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookController>(
      builder: (context, controller, _)=> Scaffold(
        appBar: AppBar(
          title: const Text('Detail'),
        ),
        body: detailController!.detailBook == null
            ?
        const Center(child: CircularProgressIndicator())
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
                              builder: (context) => ImageViewScreen(imageUrl: detailController!.detailBook!.image!),
                          ),
                        );
                      },
                      child: Image.network(detailController!.detailBook!.image!,
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
                            Text(detailController!.detailBook!.title!,
                              style:
                              const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(detailController!.detailBook!.authors!,
                              style:
                              const TextStyle(
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(height: 15,),
                            Text(detailController!.detailBook!.subtitle!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Row(
                              children:
                                List.generate(
                                  5, (index) => Icon(Icons.star,
                                  color: index < int.parse(detailController!.detailBook!.rating!)
                                      ? Colors.green // if index less than rate
                                      : Colors.grey, // if index is equal or more than rate
                              ),
                              ),
                            ),
                            Text(detailController!.detailBook!.price!,
                              style:
                              const TextStyle(
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
                const SizedBox(height: 5,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    //style: ElevatedButton,
                    onPressed: () async {
                      //print('url');
                      Uri uri = Uri.parse(detailController!.detailBook!.url!);
                      try {
                        !await canLaunchUrl(uri)
                            ? launchUrl(uri)
                            : debugPrint('Unable to navigate');
                      } catch (e) {
                        debugPrint('error');
                        debugPrint(e.toString());
                      }
                    },
                    child: const Text('Buy'),
                  ),
                ),
                const SizedBox(height: 10,),
                Text(detailController!.detailBook!.desc!,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //Text(detailBook!.isbn10!),
                    Text('Year: ${detailController!.detailBook!.year!}',
                    ),
                    Text('ISBN: ${detailController!.detailBook!.isbn13!}',
                    ),
                    Text('${detailController!.detailBook!.pages!} Pages',
                    ),
                    Text('Publisher: ${detailController!.detailBook!.publisher!}',
                    ),
                    Text('Language: ${detailController!.detailBook!.language!}',
                    ),
                  ],
                ),
                const Divider(
                  height: 40,
                  thickness: 5,
                ),
                detailController!.similarBooks == null
                ? const CircularProgressIndicator()
                : Expanded(
                  child: SizedBox(
                    height: 150,
                    child: ListView.builder(
                      // shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: detailController!.similarBooks!.books!.length,
                      // physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index){
                        final current = detailController!.similarBooks!.books![index];
                        return Container(
                          width: 80,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.network(current.image!,
                                ),
                              ),
                              Expanded(child: Text(current.title!,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
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
      ),
    );
  }
}
