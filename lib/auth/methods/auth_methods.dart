import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:ohstel_hostel_app/auth/models/login_user_model.dart';
import 'package:ohstel_hostel_app/auth/models/userModel.dart';
import 'package:ohstel_hostel_app/hive_methods/hive_class.dart';

import 'auth_database_methods.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // create login user object
  LoginUserModel userFromFirebase(User user) {
    return user != null ? LoginUserModel(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<LoginUserModel> get userStream {
    /// emit a stream of user current state(e.g emit an event when the user
    /// log out so the UI can be notify and update as needed or emit a event when
    /// a user log in so the UI can also be updated

    return auth.authStateChanges().map(userFromFirebase);
  }

  // log in with email an pass
  Future loginWithEmailAndPassword(
      {@required String email, @required String password}) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = result.user;

      await getUserDetails(uid: user.uid);

      return userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.message, toastLength: Toast.LENGTH_LONG);
      return null;
    }
  }

  // register with email an pass
  Future registerWithEmailAndPassword({
    @required String email,
    @required String password,
    @required String fullName,
    @required String userName,
    @required String schoolLocation,
    @required String phoneNumber,
    @required String uniName,
    @required Map uniDetails,
  }) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User user = result.user;

      // add user details to firestore database
      await AuthDatabaseMethods().createUserDataInFirestore(
        uid: user.uid,
        email: email,
        fullName: fullName,
        userName: userName,
        schoolLocation: schoolLocation,
        phoneNumber: phoneNumber,
        uniName: uniName,
        uniDetails: uniDetails,
      );

      UserModel userData = UserModel(
        uid: user.uid,
        email: email,
        fullName: fullName,
        userName: userName,
        schoolLocation: schoolLocation,
        phoneNumber: phoneNumber,
        uniName: uniName,
        uniDetails: uniDetails,
      );

      // save user info to local database using hive
      await saveUserDataToDb(userData: userData.toMap());
      setUserWalletDetails(uid: userData.uid);

      return userFromFirebase(user);
    } catch (e) {
      Fluttertoast.showToast(msg: e.message, toastLength: Toast.LENGTH_LONG);
      print(e.toString());
      return null;
    }
  }

  // signing out method
  Future signOut() async {
    try {
//      await deleteAllUserDataToDb();
      return await auth.signOut();
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '${e.message}');
    }
  }

  Future restEmail({@required String email}) async {
    try {
      return auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '${e.message}');
    }
  }

//  Future getUserDetails({@required String uid}) async {

  Future<UserModel> getUserDetails({@required String uid}) async {
    UserModel userDetails;
    final CollectionReference userDataCollectionRef =
        FirebaseFirestore.instance.collection('userData');
    print(uid.trim());
    try {
      DocumentSnapshot document = await userDataCollectionRef.doc(uid).get();
      print(document.data());
      await saveUserDataToDb(userData: document.data());
      userDetails = UserModel.fromMap(document.data().cast<String, dynamic>());
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '${e.message}');
    }

    return userDetails;
  }

  Future<UserModel> getUserDetailsByUid({@required String uid}) async {
    UserModel userDetails;
    final CollectionReference userDataCollectionRef =
        FirebaseFirestore.instance.collection('userData');
    print(uid.trim());
    try {
      DocumentSnapshot document = await userDataCollectionRef.doc(uid).get();
      print(document.data());
      userDetails = UserModel.fromMap(document.data().cast<String, dynamic>());
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '${e.message}');
    }

    return userDetails;
  }

  Future<void> saveUserDataToDb({@required Map userData}) async {
    print('saving..................');
    Box<Map> userDataBox = await HiveMethods().getOpenBox('userDataBox');
    final key = 0;
    final value = userData;
    print(userData);

    userData['dateJoined'] = userData["dateJoined"].toString();
    print(userData);

    await userDataBox.put(key, value);
    print('saved');
  }

  Future<void> deleteAllUserDataToDb() async {
    Box<Map> userDataBox = await HiveMethods().getOpenBox('userDataBox');
    Box<Map> marketDataBox = await HiveMethods().getOpenBox('cart');
    Box<Map> foodDataBox = await HiveMethods().getOpenBox('marketCart');
    final key = 0;

    userDataBox.delete(key);
    marketDataBox.clear();
    foodDataBox.clear();
  }

  Future<void> setUserWalletDetails({@required String uid}) async {
    await FirebaseFirestore.instance.collection('wallet').doc(uid).set({});
  }
}
