import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:localdata_with_hive/view/put_data.dart';
import 'package:localdata_with_hive/view/theme_page.dart';

import '../main.dart';

List<Map<String, dynamic>> boxList = [];

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var box = Hive.box("BoxTest");
  var box1 = Hive.box("theme");


  Future<dynamic>? _addToBox({
    required String title,
    required String details,
  }) async {
    await box.add({
      "title": title,
      "details": details,
    });
    _getFromBox();
    setState(() {});
  }

  Future<dynamic>? _getFromBox() {
    boxList =box.keys.map((e) {
      final current =  box.get(e);
      return {
        "key": e,
        "title": current['title'],
        "details": current['details'],
      };
    }).toList();
    debugPrint('$boxList');
    setState(() {});
  }

  Future<dynamic>? _deleteFromBox({required int key}) async {
    await box.delete(key);
    _getFromBox();
    setState(() {});
  }

  @override
  void initState() {
    _getFromBox();
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
            onPressed: () {
              _scaffoldState.currentState!.openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            )),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: SearchBox());
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              )),
          ValueListenableBuilder(
            valueListenable: Hive.box('theme').listenable(),
            builder: (context, box, widget) {
              var darkMode = box.get('darkMode', defaultValue: false);
              return Center(
                child: Switch(
                  value: darkMode,
                  onChanged: (val) {
                    box.put('darkMode', !darkMode);
                  },
                ),
              );
            },
          ),
          // IconButton(
          //     onPressed: () {
          //       // showSearch(context: context, delegate: SearchBox());
          //       Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ThemePage()));
          //     },
          //     icon: const Icon(
          //       Icons.dark_mode,
          //       color: Colors.white,
          //     )),
        ],
      ),
      drawer: Drawer(
        // width: MediaQuery.of(context).size.width / 2,
        backgroundColor: Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Add Your Task ...!'),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                minLines: 1,
                maxLines: 5,
                controller: _titleController,
                decoration: InputDecoration(
                    hintText: 'Add Title ',
                    // labelText: 'Title',
                    hintStyle: const TextStyle(fontSize: 15),
                    contentPadding: const EdgeInsets.all(8.0),
                    filled: true,
                    fillColor: Colors.deepPurple.shade100),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                minLines: 1,
                maxLines: 10,
                controller: _detailsController,
                decoration: InputDecoration(
                    hintText: 'Add Details ',
                    // labelText: 'Title',
                    hintStyle: const TextStyle(fontSize: 15),
                    contentPadding: const EdgeInsets.all(8.0),
                    filled: true,
                    fillColor: Colors.deepPurple.shade100),
              ),
              const SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.deepPurple)),
                  onPressed: () {
                    if (_titleController.text.isEmpty &&
                        _detailsController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Sure in Complete Field '),
                        backgroundColor: Colors.red,
                      ));
                    } else {
                      _addToBox(
                              title: _titleController.text,
                              details: _detailsController.text)
                          ?.then((value) {
                        _titleController.clear();
                        _detailsController.clear();
                      });
                      _scaffoldState.currentState!.closeDrawer();
                    }
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ),
        ),
      ),
      body: boxList.isEmpty
          ? const Center(
              child: Icon(
              Icons.remove_road_rounded,
              size: 100,
              color: Colors.deepPurple,
            ))
          : SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                     Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('**  Box Tasks  **' ,
                      style: TextStyle(fontWeight: FontWeight.bold , fontSize: 22.0 ,
                        color: Theme.of(context).textTheme.labelMedium?.color,
                      ),),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(10.0),
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          '${boxList[index]['title']}',
                          style:  const TextStyle(
                              // color: darkMode ? Colors.deepPurple : Colors.black,
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                          maxLines: 2,
                        ),
                        subtitle: Text(
                          '${boxList[index]['details']}',
                          style:  const TextStyle(
                              // color: darkMode ? Colors.deepPurple : Colors.black,
                              fontSize: 15.0, fontWeight: FontWeight.w500),
                          maxLines: 5,
                        ),
                        contentPadding: const EdgeInsets.all(30.0),
                        leading: const Icon(
                          Icons.task,
                          color: Colors.green,
                        ),
                        // tileColor:darkMode ? Colors.deepPurple  : Colors.grey.shade100,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                _deleteFromBox(key: boxList[index]['key']);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            IconButton(
                              onPressed: () {
                                // _deleteFromBox(key: _boxList[index]['key']);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => PutData(
                                          keyBox: boxList[index]['key'],
                                          details: boxList[index]['title'],
                                          title: boxList[index]['details'],
                                          titleController: _titleController,
                                          detailsController: _detailsController,
                                        )));
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.amber,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: boxList.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
                      height: 10.0,
                    ),
                  )
                  // GridView.builder(
                  //   itemCount: boxList.length,
                  //     padding: const EdgeInsets.all(10.0),
                  //     shrinkWrap: true,
                  //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //         crossAxisCount: 2,
                  //     crossAxisSpacing: 10.0,
                  //       mainAxisSpacing: 10.0,
                  //       childAspectRatio: 1
                  //     ),
                  //     itemBuilder: (context , index){
                  //   return ListTile(
                  //     title: Text(
                  //       '${boxList[index]['title']}',
                  //       style:  TextStyle(
                  //         color: darkMode ? Colors.deepPurple : Colors.white,
                  //           fontSize: 18.0, fontWeight: FontWeight.bold),
                  //       maxLines: 2,
                  //     ),
                  //     subtitle: Text(
                  //       '${boxList[index]['details']}',
                  //       style:  TextStyle(
                  //           color: darkMode ? Colors.deepPurple : Colors.white,
                  //           fontSize: 15.0, fontWeight: FontWeight.w500),
                  //       maxLines: 5,
                  //     ),
                  //     contentPadding: const EdgeInsets.all(30.0),
                  //     leading: const Icon(
                  //       Icons.task,
                  //       color: Colors.green,
                  //     ),
                  //     tileColor: darkMode ? Colors.deepPurple.shade100 :  Colors.grey.shade100,
                  //     shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10.0)),
                  //     trailing: Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         IconButton(
                  //           onPressed: () {
                  //             _deleteFromBox(key: boxList[index]['key']);
                  //           },
                  //           icon: const Icon(
                  //             Icons.delete,
                  //             color: Colors.red,
                  //           ),
                  //           padding: EdgeInsets.zero,
                  //         ),
                  //         IconButton(
                  //           onPressed: () {
                  //             // _deleteFromBox(key: _boxList[index]['key']);
                  //             Navigator.of(context).push(MaterialPageRoute(
                  //                 builder: (_) => PutData(
                  //                   keyBox: boxList[index]['key'],
                  //                   details: boxList[index]['title'],
                  //                   title: boxList[index]['details'],
                  //                   titleController: _titleController,
                  //                   detailsController: _detailsController,
                  //                 )));
                  //           },
                  //           icon: const Icon(
                  //             Icons.edit,
                  //             color: Colors.amber,
                  //           ),
                  //           padding: EdgeInsets.zero,
                  //         ),
                  //       ],
                  //     ),
                  //   );
                  // })
                ],
              ),
            ),
    );
  }
}

class SearchBox extends SearchDelegate<dynamic> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(
            Icons.clear,
            color: Colors.red,
          ))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.deepPurple,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    var listSearch = boxList
        .where((element) => element['title']
            .toString()
            .toLowerCase()
            .startsWith(query.toLowerCase()))
        .toList();

    return listSearch.isEmpty ?
        const Center(child: Text('No Data Found !'),)
        :  ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemBuilder: (context, index) {
        return SizedBox(
            height: 80,
            child: Card(
              color: Colors.deepPurple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${listSearch[index]['title']}\n${listSearch[index]['details']}',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ));
      },
      itemCount: listSearch.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text('Start Search'),
    );
  }
}
