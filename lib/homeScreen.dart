import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news/categoriesScreen.dart';
import 'package:news/main.dart';
import 'package:news/model/modelAllNews.dart';
import 'package:news/model/modelBBcNews.dart';
import 'package:news/newsDetailScreen.dart';
import 'package:news/view_model/newsListViewModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NewsListViewModel newsListViewModel = NewsListViewModel();
  final format = new DateFormat('MMMM dd,yyyy');
  bool _isSortedByDate = false; // State variable to track sorting order
  bool _showAllNews = false; // State variable to track whether to show all news
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    double Kwidth = MediaQuery.of(context).size.width;
    double Kheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CategoriesScreen()));
          },
          icon: Image.asset(
            'images/category_icon.png',
            height: Kheight * 0.05,
            width: Kwidth * 0.05,
          ),
        ),
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search news...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.black87),
          ),
          style: TextStyle(color: Colors.black87),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.black87),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: Kheight * 0.55,
            child: FutureBuilder<ModelBbcNews>(
              future: newsListViewModel.fetchBBcNews(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: spinkit);
                } else {
                  if (_isSortedByDate) {
                    // Sort articles by date
                    snapshot.data!.articles!.sort((a, b) =>
                        DateTime.parse(b.publishedAt!)
                            .compareTo(DateTime.parse(a.publishedAt!)));
                  }

                  var filteredArticles = snapshot.data!.articles!
                      .where((article) => article.title!
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()))
                      .toList();

                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: filteredArticles.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(
                          filteredArticles[index].publishedAt!);

                      return Container(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Kheight * 0.02),
                              height: Kheight * 0.6,
                              width: Kwidth * 0.9,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "${filteredArticles[index].urlToImage!}",
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      Container(child: spinkit2),
                                  errorWidget: (context, url, error) =>
                                      new Icon(Icons.error),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              child: InkWell(
                                onTap: () {
                                  String newsImage =
                                      filteredArticles[index].urlToImage!;
                                  String newsTitle =
                                      filteredArticles[index].title!;
                                  String newsDate =
                                      filteredArticles[index].publishedAt!;
                                  String newsAuthor =
                                      filteredArticles[index].author!;
                                  String newsDesc =
                                      filteredArticles[index].description!;
                                  String newsContent =
                                      filteredArticles[index].content!;
                                  String newsSource =
                                      filteredArticles[index].source!.name!;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NewsDetailScreen(
                                        newsImage,
                                        newsTitle,
                                        newsDate,
                                        newsAuthor,
                                        newsDesc,
                                        newsContent,
                                        newsSource,
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  elevation: 5,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    padding: EdgeInsets.all(10),
                                    height: Kheight * 0.22,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: Kwidth * 0.7,
                                          child: Text(
                                            '${filteredArticles[index].title!}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 17,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          width: Kwidth * 0.7,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: Text(
                                                    '${filteredArticles[index].source!.name}',
                                                    softWrap: true,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      color: Colors.blueAccent,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                '${format.format(dateTime)}',
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          if (_showAllNews)
            FutureBuilder<ModelAllNews>(
              future: newsListViewModel.fetchNews('general'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('');
                } else {
                  if (_isSortedByDate) {
                    // Sort articles by date
                    snapshot.data!.articles!.sort((a, b) =>
                        DateTime.parse(b.publishedAt!)
                            .compareTo(DateTime.parse(a.publishedAt!)));
                  }

                  var filteredArticles = snapshot.data!.articles!
                      .where((article) => article.title!
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()))
                      .toList();

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: new NeverScrollableScrollPhysics(),
                    itemCount: filteredArticles.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(
                          filteredArticles[index].publishedAt!);

                      return InkWell(
                        onTap: () {
                          String newsImage =
                              filteredArticles[index].urlToImage!;
                          String newsTitle =
                              filteredArticles[index].title!;
                          String newsDate =
                              filteredArticles[index].publishedAt!;
                          String newsAuthor =
                              filteredArticles[index].author!;
                          String newsDesc =
                              filteredArticles[index].description!;
                          String newsContent =
                              filteredArticles[index].content!;
                          String newsSource =
                              filteredArticles[index].source!.name!;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewsDetailScreen(
                                newsImage,
                                newsTitle,
                                newsDate,
                                newsAuthor,
                                newsDesc,
                                newsContent,
                                newsSource,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.symmetric(
                              horizontal: Kwidth * 0.04,
                              vertical: Kheight * 0.02),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "${filteredArticles[index].urlToImage!}",
                                  height: Kheight * 0.18,
                                  width: Kwidth * 0.3,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      Container(child: spinkit2),
                                  errorWidget: (context, url, error) =>
                                      new Icon(Icons.error),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                height: Kheight * 0.18,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: Kwidth * 0.59,
                                      child: Text(
                                        '${filteredArticles[index].title!}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      width: Kwidth * 0.56,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                '${filteredArticles[index].source!.name}',
                                                softWrap: true,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  color: Colors.blueAccent,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '${format.format(dateTime)}',
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter News'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Filter options will be here'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isSortedByDate = !_isSortedByDate;
                  });
                  Navigator.of(context).pop();
                },
                child: Text(_isSortedByDate ? 'Unsort by Date' : 'Sort by Date'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showAllNews = !_showAllNews;
                  });
                  Navigator.of(context).pop();
                },
                child: Text(_showAllNews ? 'Hide All News' : 'Show All News'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

const spinkit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50.0,
);