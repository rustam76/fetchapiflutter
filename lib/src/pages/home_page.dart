import 'dart:convert';

import 'package:datafilmflutter/src/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as getUrl;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> data = [];
  List<dynamic> filteredList = [];

  Future<List<dynamic>> fetchData() async {
    final result = await getUrl.get(Uri.parse(urlData.urlstations));
    if (result.statusCode == 200) {
      final List<dynamic> fetchedData = jsonDecode(result.body);
      return fetchedData;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  void searchItem(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredList = data;
      } else {
        filteredList = data
            .where((item) =>
                item['code'].toLowerCase().contains(query.toLowerCase()) ||
                item['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData().then((fetchedData) {
      setState(() {
        data = fetchedData;
        filteredList = data; 
      });
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Stasiun Kereta Indonesia'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SizedBox(height: 10),
                TextField(
                  onChanged: searchItem,
                  decoration: InputDecoration(
                    hintText: 'Search by kode and name ...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          children: [
                            ExpansionTile(
                              title:
                                  Text('kode: ${filteredList[index]['code']}'),
                              children: [
                                Text('nama: ${filteredList[index]['name']}'),
                                SizedBox(height: 10),
                                Text('kota: ${filteredList[index]['city']}'),
                                SizedBox(height: 10),
                                Text(
                                    'keterangan: ${filteredList[index]['cityname']}'),
                                SizedBox(height: 10),
                              ],
                            ),
                            Divider(), 
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            )),
      ),
    );
  }
}
