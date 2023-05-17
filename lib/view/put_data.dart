import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:localdata_with_hive/view/my_home_page.dart';

class PutData extends StatefulWidget {
  final int keyBox;

  final String title;

  final String details;

  final TextEditingController titleController;

  final TextEditingController detailsController;

  final box = Hive.box("BoxTest");

  PutData(
      {Key? key,
      required this.keyBox,
      required this.details,
      required this.title,
      required this.titleController,
      required this.detailsController})
      : super(key: key);

  @override
  State<PutData> createState() => _PutDataState();
}

class _PutDataState extends State<PutData> {
  // final TextEditingController _titleController = TextEditingController();
  // final TextEditingController _detailsController = TextEditingController();

  Future<dynamic>? _updateItemFromBox() async {
    await widget.box.put(widget.keyBox, {
      "title": widget.titleController.text,
      "details": widget.detailsController.text,
    });
    setState(() {});
  }

  @override
  void initState() {
    widget.titleController.text = widget.title;
    widget.detailsController.text = widget.details;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                minLines: 1,
                maxLines: 5,
                controller: widget.titleController,
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
                controller: widget.detailsController,
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
                    if (widget.titleController.text.isEmpty &&
                        widget.detailsController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Sure in Complete Field '),
                        backgroundColor: Colors.red,
                      ));
                    } else {
                      _updateItemFromBox();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const MyHomePage()),
                          (route) => false);
                      setState(() {});
                    }
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
