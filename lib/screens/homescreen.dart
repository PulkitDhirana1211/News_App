import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/common/debouncer.dart';
import 'package:news_app/common/specific_news.dart';
import 'package:news_app/models/general_news_model.dart';
import 'package:news_app/models/model.dart';
import 'package:news_app/view_model/news_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum countryList { us, kr, jp }

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController textEditingController = TextEditingController();
  NewsViewModel newsViewModel = NewsViewModel();
  final _debouncer = Debouncer(milliseconds: 500);
  String name = 'us';
  String query = 'us';
  countryList? selectedCountry;
  final format = DateFormat('MMMM dd, yyyy');
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Image.asset(
            'assets/images/menu.png',
            height: 30,
            width: 30,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          "News App",
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        actions: [
          PopupMenuButton<countryList>(
            initialValue: selectedCountry,
            onSelected: (countryList countryVal) {
              if (countryList.us.name == countryVal.name) {
                name = "us";
              } else if (countryList.kr.name == countryVal.name) {
                name = "kr";
              } else if (countryList.jp.name == countryVal.name) {
                name = "jp";
              }
              setState(() {
                selectedCountry = countryVal;
                name = countryVal.name;
                query = name;
                textEditingController.text='';
              });
            },
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            itemBuilder: (context) => <PopupMenuEntry<countryList>>[
              const PopupMenuItem<countryList>(
                  value: countryList.us, child: Text("USA")),
              const PopupMenuItem<countryList>(
                  value: countryList.kr, child: Text("South Korea")),
              const PopupMenuItem<countryList>(
                  value: countryList.jp, child: Text("Japan")),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: TextFormField(
                controller: textEditingController,
                onChanged: (value) {
                  if(textEditingController.text.isNotEmpty){
                  _debouncer.run(
                    () {
                      setState(() {
                        query = value;
                      });
                    },
                  );
                  }
                },
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.search)),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black45)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black45)),
                    contentPadding: const EdgeInsets.all(16)),
              ),
            ),
            textEditingController.text.isEmpty?
            SizedBox(
              height: height * 0.55,
              child: FutureBuilder<NewsHeadlinesModel>(
                future: selectedCountry == null
                    ? newsViewModel.fetchNewsHeadlines()
                    : newsViewModel.fetchCountryNews(name),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.blue,
                    );
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context, index) {
                        if (snapshot.data!.articles![index].author == null ||
                            snapshot.data!.articles![index].urlToImage ==
                                null) {
                          return Container();
                                }
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.02,
                              vertical: height * 0.02),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SpecificNews(
                                            author: snapshot
                                                .data!.articles![index].author,
                                            description: snapshot.data!
                                                .articles![index].description,
                                            imageUrl: snapshot.data!
                                                .articles![index].urlToImage,
                                            title: snapshot
                                                .data!.articles![index].title,
                                            publishedAt: snapshot.data!
                                                .articles![index].publishedAt,
                                            source: snapshot.data!
                                                .articles![index].source!.name,
                                          )));
                            },
                            child: Card(
                              elevation: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: height * 0.3,
                                    width: width * 0.9,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot
                                            .data!.articles![index].urlToImage
                                            .toString(),
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(
                                          child: spinKit,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: width * 0.9,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.07,
                                        vertical: height * 0.01),
                                    child: Text(
                                      snapshot.data!.articles![index].title
                                          .toString(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: GoogleFonts.poppins(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  SizedBox(
                                    width: width * 0.9,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width * 0.08,
                                              vertical: height * 0.01),
                                          child: Text(
                                            snapshot.data!.articles![index]
                                                .source!.name
                                                .toString(),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            style: GoogleFonts.poppins(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width * 0.04,
                                              vertical: height * 0.01),
                                          child: Text(
                                            DateFormat("MMMM dd, yyyy").format(
                                                DateTime.parse(snapshot
                                                    .data!
                                                    .articles![index]
                                                    .publishedAt
                                                    .toString())),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            style: GoogleFonts.poppins(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ):SizedBox(
              height: height * 0.55,
              child: FutureBuilder<GeneralNewsModel>(
                future: query.isNotEmpty? newsViewModel.fetchGeneralNews2(query):newsViewModel.fetchGeneralNews('us'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator.adaptive(
                      value: 0.5,
                      backgroundColor: Colors.blue,
                    );
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context, index) {
                        if (snapshot.data!.articles![index].author == null ||
                            snapshot.data!.articles![index].urlToImage ==
                                null) {
                          return Container();
                                }
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.02,
                              vertical: height * 0.02),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SpecificNews(
                                            author: snapshot
                                                .data!.articles![index].author,
                                            description: snapshot.data!
                                                .articles![index].description,
                                            imageUrl: snapshot.data!
                                                .articles![index].urlToImage,
                                            title: snapshot
                                                .data!.articles![index].title,
                                            publishedAt: snapshot.data!
                                                .articles![index].publishedAt,
                                            source: snapshot.data!
                                                .articles![index].source!.name,
                                          )));
                            },
                            child: Card(
                              elevation: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: height * 0.3,
                                    width: width * 0.9,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot
                                            .data!.articles![index].urlToImage
                                            .toString(),
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(
                                          child: spinKit,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: width * 0.9,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.07,
                                        vertical: height * 0.01),
                                    child: Text(
                                      snapshot.data!.articles![index].title
                                          .toString(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: GoogleFonts.poppins(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  SizedBox(
                                    width: width * 0.9,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width * 0.08,
                                              vertical: height * 0.01),
                                          child: Text(
                                            snapshot.data!.articles![index]
                                                .source!.name
                                                .toString(),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            style: GoogleFonts.poppins(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width * 0.04,
                                              vertical: height * 0.01),
                                          child: Text(
                                            DateFormat("MMMM dd, yyyy").format(
                                                DateTime.parse(snapshot
                                                    .data!
                                                    .articles![index]
                                                    .publishedAt
                                                    .toString())),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            style: GoogleFonts.poppins(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            SizedBox(
              height: height,
              child: FutureBuilder<GeneralNewsModel>(
                future: query.isNotEmpty
                    ? newsViewModel.fetchGeneralNews(query)
                    : newsViewModel.fetchGeneralNews('us'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // return Center(
                    //   child: SpinKitCircle(
                    //     color: Colors.blue,
                    //     size: 50,
                    //   ),
                    // );
                    return const CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.blue,
                      value: 20,
                    );
                  } else {
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context, index) {
                        if (snapshot.data!.articles![index].author == null ||
                            snapshot.data!.articles![index].urlToImage ==
                                null) {
                          return Container();
                        }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SpecificNews(
                                            author: snapshot
                                                .data!.articles![index].author,
                                            description: snapshot.data!
                                                .articles![index].description,
                                            imageUrl: snapshot.data!
                                                .articles![index].urlToImage,
                                            title: snapshot
                                                .data!.articles![index].title,
                                            publishedAt: snapshot.data!
                                                .articles![index].publishedAt,
                                            source: snapshot.data!
                                                .articles![index].source!.name,
                                          )));
                            },
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot
                                        .data!.articles![index].urlToImage
                                        .toString(),
                                    fit: BoxFit.cover,
                                    height: height * 0.18,
                                    width: width * 0.3,
                                    placeholder: (context, url) => Container(
                                      child: spinKit,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: height * 0.18,
                                    padding: EdgeInsets.only(left: 10, top: 6),
                                    child: Column(
                                      //                                  mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          snapshot.data!.articles![index].title
                                              .toString(),
                                          maxLines: 3,
                                          style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                              fontWeight: FontWeight.w700),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const spinKit = SpinKitCircle(
  color: Colors.amber,
  size: 50,
);
