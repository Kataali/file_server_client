import '../models/file.dart';
import 'package:flutter/foundation.dart';

class FileData extends ChangeNotifier {
  // ignore: prefer_final_fields
  List<File> _allFiles = [
    // File(
    //   title: "Naming Ceremony",
    //   type: "JPG",
    //   description:
    //       "The file represents a sample of the naming ceremony card design.",
    //   uploadedOn: DateTime.now.toString(),
    //   id: 1,
    //   path: '__',
    // ),
    // File(
    //     id: 2,
    //     title: "Naming Ceremony",
    //     type: "PDF",
    //     description:
    //         "The file represents a sample of the naming ceremony card design.",
    //     uploadedOn: DateTime.now.toString(),
    //     path: "__"),
    // File(
    //     id: 3,
    //     title: "Naming Ceremony",
    //     type: "PNG",
    //     description:
    //         "The file represents a sample of the naming ceremony card design.",
    //     uploadedOn: DateTime.now.toString(),
    //     path: "__")
  ];

  // ignore: prefer_final_fields
  // List<File> _searchedFiles = [
  //   File(
  //     title: "Naming Ceremony",
  //     type: "JPG",
  //     description:
  //         "The file represents a sample of the naming ceremony card design.",
  //     uploadedOn: DateTime.now.toString(),
  //     id: 1,
  //     path: '__',
  //   ),
  //   File(
  //       id: 2,
  //       title: "Naming Ceremony",
  //       type: "PDF",
  //       description:
  //           "The file represents a sample of the naming ceremony card design.",
  //       uploadedOn: DateTime.now.toString(),
  //       path: "__"),
  //   File(
  //       id: 3,
  //       title: "Naming Ceremony",
  //       type: "PNG",
  //       description:
  //           "The file represents a sample of the naming ceremony card design.",
  //       uploadedOn: DateTime.now.toString(),
  //       path: "__")
  // ];
  // ignore: prefer_final_fields
  List<File> _searchedFiles = [];

  // Add a file to the all files list
  void addFile(File product) {
    _allFiles.add(product);
    notifyListeners();
  }

  // Remove a file from all files list
  void removeFile(File product) {
    _allFiles.remove(product);
    notifyListeners();
  }

  // Empty all files list
  void emptyVitalsList() {
    _allFiles.clear();
  }

  // Empty searched files list
  void emptysearchedList() {
    _searchedFiles.clear();
  }

  // merge a list with the all files list
  void mergeWithFilesList(List<File> newFiles) {
    _allFiles.addAll(newFiles);
    notifyListeners();
  }

  // merge a list with the searched files list
  void mergeWithSearchedFilesList(List<File> newFiles) {
    _searchedFiles.addAll(newFiles);
    notifyListeners();
  }

  // get length of all files list
  int get filesLength => _allFiles.length;

  // Get each file in the all files list by index
  File getFileByIndex(int index) => _allFiles[index];

  // get length of searched files list
  int get searchedFilesLength => _searchedFiles.length;

  // Get each file in the searched files list by index
  File getSearchedFileByIndex(int index) => _searchedFiles[index];
}
