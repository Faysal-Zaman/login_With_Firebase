import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../widgets/build_progress.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  bool cond = false;

  Future uploadFile() async {
    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print("Download Link: $urlDownload");

    setState(() {
      uploadTask = null;
      cond = true;
    });
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Upload Files to Firebase",
            style: TextStyle(color: Colors.amber),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              (pickedFile != null)
                  ? Expanded(
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          child: Image.file(
                            File(pickedFile!.path!),
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 200,
                      child:
                          Image.asset('assets/butterfly.png', fit: BoxFit.fill),
                    ),
              const SizedBox(
                height: 50,
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: selectFile,
                child: const Text("Select File"),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: uploadFile,
                child: const Text("Upload File"),
              ),
              const SizedBox(
                height: 30,
              ),
              BuildProgress(uploadTask: uploadTask),
              (cond == true)
                  ? SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        const UploadPage())));
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          alignment: Alignment.center,
                          backgroundColor: Colors.amber,
                          elevation: 0,
                          textStyle: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        child: const Text(
                          "Click to upload another file",
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(
                      height: 0,
                      width: 0,
                    )
            ],
          ),
        ),
      ),
    );
  }
}
