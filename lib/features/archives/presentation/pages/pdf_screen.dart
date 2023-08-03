import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFViewPage extends StatefulWidget {
  final File file;

  PDFViewPage({Key? key, required this.file}) : super(key: key);

  @override
  _PDFViewPageState createState() => _PDFViewPageState();
}

class _PDFViewPageState extends State<PDFViewPage> {
  int _totalPages = 0;
  int _currentPage = 0;
  bool pdfReady = false;
  late PDFViewController _pdfViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.file.path,
            enableSwipe: true,
            swipeHorizontal: false, // Display pages vertically
            autoSpacing: true, // Enable auto spacing
            pageFling: true,
            onRender: (_pages) {
              setState(() {
                _totalPages = _pages!;
                pdfReady = true;
              });
            },
            onError: (error) {
              print(error.toString());
            },
            onPageError: (page, error) {
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _pdfViewController = pdfViewController;
            },
            onPageChanged: (int? page, int? total) {
              if (page != null && total != null) {
                setState(() {
                  _currentPage = page + 1;
                });
              }
            },
          ),
          Positioned(
            top: 40.0,
            left: 0.0,
            right: 0.0,
            child: Center(
              child: pdfReady
                  ? Text("Página $_currentPage de $_totalPages",
                      style: TextStyle(fontSize: 16.0, color: Colors.black))
                  : Container(),
            ),
          ),
          !pdfReady
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Offstage()
        ],
      ),
    );
  }
}
