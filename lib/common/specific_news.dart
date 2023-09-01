import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SpecificNews extends StatefulWidget {
  final String? imageUrl, author, description, title, source, publishedAt;
  SpecificNews(
      {super.key,
      required this.imageUrl,
      required this.author,
      required this.description,
      required this.title,
      required this.source,
      required this.publishedAt});

  @override
  State<SpecificNews> createState() => _SpecificNewsState();
}

class _SpecificNewsState extends State<SpecificNews> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;

    return Scaffold(
      appBar: AppBar(),
      body: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox(
              height: height * 0.5,
              width: width,
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl.toString(),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            Positioned(
              bottom: -350,
              child: Container(
                
                alignment: Alignment.bottomCenter,
                height: height * 0.6,
                width: width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.07, vertical: height * 0.01),
                      child: Text(
                        widget.title.toString(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 6,
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.07),
                            child: Text(
                              widget.source.toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.04,
                                vertical: height * 0.01),
                            child: Text(
                              DateFormat("MMMM dd, yyyy").format(DateTime.parse(
                                  widget.publishedAt.toString())),
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
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.07, vertical: height * 0.01),
                      child: Text(
                        widget.description.toString(),
                        maxLines: 12,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]),
    );
  }
}
