import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:native_pdf_view/native_pdf_view.dart';

class DetailZurnal extends StatelessWidget {
  final url;
  final i;
  
  DetailZurnal({
    this.url, 
    this.i
    });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Neşir ${i+1} Güneş žurnaly'),
      ),
      body:  PDF(
        swipeHorizontal: true,
      ).cachedFromUrl(url),
      
    );
  }
}