import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'model/hostel_model.dart';

class HostelBookingMethods {
  CollectionReference hostelRef =
  FirebaseFirestore.instance.collection('hostelBookings');

  CollectionReference hostelInspectionRef =
  FirebaseFirestore.instance.collection('bookingInspections');

  CollectionReference paidHostelRef =
      FirebaseFirestore.instance.collection('paidHostel');

  Future saveHostelToServer({@required HostelModel hostelModel}) async {
    try {
      print('saving');
      await hostelRef.doc(hostelModel.id).set(hostelModel.toMap());
      print('saved');
    } catch (err) {
      print(err);
      Fluttertoast.showToast(msg: '$err');
    }
  }

  Future confirmInspection({@required String id}) async {
    try {
      await hostelInspectionRef
          .doc(id)
          .update({'inspectionMade': true});
      print('done');
      Fluttertoast.showToast(msg: 'Comfirmed!!');
    } catch (err) {
      print(err);
      Fluttertoast.showToast(msg: '$err');
    }
  }

  Future isClaimed({@required String id}) async {
    try {
      await paidHostelRef.doc(id).update({'isClaimed': true});
      Fluttertoast.showToast(msg: 'Comfirmed!!');
    } catch (err) {
      print(err);
      Fluttertoast.showToast(msg: '$err');
    }
  }

  Future<List<HostelModel>> fetchHostelByKeyWord(
      {@required String keyWord, @required String uniName}) async {
    List<HostelModel> hostelList = List<HostelModel>();

    QuerySnapshot querySnapshot = await hostelRef
        .where('hostelName', isGreaterThanOrEqualTo: keyWord)
        .orderBy('hostelName', descending: true)
        .limit(6)
        .get();

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      print('key : $keyWord');
      debugPrint(
          'hostel Name: ${querySnapshot.docs[i].data()['hostelName']}');

      hostelList.add(HostelModel.fromMap(querySnapshot.docs[i].data()));
    }

    print(hostelList);
    print(hostelList.length);
    return hostelList;
  }

  Future<List<HostelModel>> fetchHostelByKeyWordWithPagination({
    @required String keyWord,
    @required HostelModel lastHostel,
    @required String uniName,
  }) async {
    print(lastHostel.id);
    List<HostelModel> hostelList = List<HostelModel>();

    QuerySnapshot querySnapshot = await hostelRef
        .where('uniName', isEqualTo: uniName)
        .orderBy('hostelName', descending: true)
        .where('hostelName', isGreaterThanOrEqualTo: keyWord)
        .startAfter([lastHostel.dateAdded])
        .limit(3)
        .get();

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      hostelList.add(HostelModel.fromMap(querySnapshot.docs[i].data()));
      print(querySnapshot.docs[i].data()['id']);
    }

    print(hostelList);
    print(hostelList.length);
    return hostelList;
  }

  Future updateHostelDetails({
    @required String id,
    @required String hostelName,
    @required int hostelPrice,
    @required bool roommateNeeded,
  }) async {
    try {
      await hostelRef.doc(id).update({
        'hostelName': hostelName,
        'price': hostelPrice,
        'isRoomMateNeeded': roommateNeeded,
      });
      print('Updated!!');
      Fluttertoast.showToast(msg: 'Updated!!');
    } catch (err) {
      print(err);
      Fluttertoast.showToast(msg: '$err');
    }
  }

  Future deleteHostelDetails({
    @required String id,
  }) async {
    try {
      await hostelRef.doc(id).delete();
      print('Deleted!!');
      Fluttertoast.showToast(msg: 'Deleted!!');
    } catch (err) {
      print(err);
      Fluttertoast.showToast(msg: '$err');
    }
  }
}
