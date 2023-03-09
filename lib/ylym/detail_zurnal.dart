import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class YlymDetails extends StatelessWidget {
  // PdfViewerController? _pdfViewerController;

  final url;
  final i;
  
  YlymDetails({
    this.url, 
    this.i
    });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Neşir ${i+1} Ýaşlaryň ylmy we tehnikasy žurnaly'),
      ),
      body:  PDF(
        swipeHorizontal: true,
      ).cachedFromUrl(url),
    );
  }
}