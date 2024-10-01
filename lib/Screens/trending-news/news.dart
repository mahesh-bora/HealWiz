// import 'dart:async';
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// class NewsScreen extends StatefulWidget {
//   @override
//   _NewsScreenState createState() => _NewsScreenState();
// }
//
// class _NewsScreenState extends State<NewsScreen> {
//   final String apiKey = 'af618d751db846319324cd1344ba3395';
//   final String apiUrl =
//       'https://gnews.io/api/v4/top-headlines?category=general&lang=en&country=us&max=10&apikey=af618d751db846319324cd1344ba3395';
//
//   late StreamController<List> _streamController;
//
//   @override
//   void initState() {
//     super.initState();
//     _streamController = StreamController<List>();
//     fetchNewsArticles();
//   }
//
//   Future<void> fetchNewsArticles() async {
//     try {
//       final response = await http.get(Uri.parse(apiUrl));
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = json.decode(response.body);
//         // Add the articles to the stream
//         _streamController.add(data['articles']);
//       } else {
//         _streamController.addError('Failed to load news');
//       }
//     } catch (e) {
//       print('Error fetching news: $e');
//       _streamController.addError('Error fetching news');
//     }
//   }
//
//   @override
//   void dispose() {
//     _streamController
//         .close(); // Close the stream controller when the widget is disposed
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('News Articles'),
//         centerTitle: true,
//       ),
//       body: StreamBuilder<List>(
//         stream: _streamController.stream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No news articles found'));
//           } else {
//             final articles = snapshot.data!;
//             return ListView.builder(
//               itemCount: articles.length,
//               itemBuilder: (context, index) {
//                 final article = articles[index];
//                 return NewsCard(article: article);
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
//
// class NewsCard extends StatelessWidget {
//   final Map article;
//
//   const NewsCard({required this.article});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       elevation: 5,
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Article Image
//             article['urlToImage'] != null
//                 ? Image.network(article['urlToImage'])
//                 : Container(),
//
//             SizedBox(height: 8),
//
//             // Article Title
//             Text(
//               article['title'] ?? 'No Title',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//
//             SizedBox(height: 8),
//
//             // Article Description
//             Text(
//               article['description'] ?? 'No Description',
//               style: TextStyle(fontSize: 14),
//             ),
//
//             SizedBox(height: 8),
//
//             // Published Date
//             Text(
//               article['publishedAt'] ?? '',
//               style: TextStyle(fontSize: 12, color: Colors.grey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healwiz/themes/theme.dart';
import 'package:http/http.dart' as http;

import '../../models/article.dart';

Future<List<Article>> fetchArticles() async {
  final response = await http.get(Uri.parse(dotenv.env['NEWS_API_KEY']!));

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body)['articles'];
    return jsonData.map((article) => Article.fromJson(article)).toList();
  } else {
    throw Exception('Failed to load articles');
  }
}

class ArticleListScreen extends StatefulWidget {
  @override
  _ArticleListScreenState createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  late Future<List<Article>> futureArticles;

  @override
  void initState() {
    super.initState();
    futureArticles = fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Trending Health News',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontSize: 27,
            fontWeight: FontWeight.w600,
          ).copyWith(fontSize: 27),
        ),
      ),
      body: FutureBuilder<List<Article>>(
        future: futureArticles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No articles found.'));
          }

          final articles = snapshot.data!;

          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return Card(
                color: AppColor.container,
                child: ListTile(
                  leading: article.imageUrl.isNotEmpty
                      ? Image.network(article.imageUrl,
                          width: 100, fit: BoxFit.cover)
                      : null,
                  title: Text(article.title),
                  subtitle: Text(article.description),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  ArticleDetailScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            article.imageUrl.isNotEmpty
                ? Image.network(article.imageUrl)
                : Container(),
            SizedBox(height: 8),
            Text(article.description, style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Open the article URL in a web view or browser
              },
              child: Text('Read more'),
            ),
          ],
        ),
      ),
    );
  }
}
