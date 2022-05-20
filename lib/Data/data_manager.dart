import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exye_app/Data/product.dart';
import 'package:exye_app/Data/timeslot.dart';
import 'package:exye_app/Data/user.dart';
import 'package:exye_app/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class DataManager {
  UserData? user;
  List<String>? productIds;
  List<Product>? products;
  List<Product>? chosen;
  CalendarData? calendar;

  String apiKey = "";
  String sessionId = "";

  String kakaoLink = "";

  File? terms;
  File? policy;

  String csNumber = "";

  List stock = [];

  List<Future<Product>?> futures = [];

  Future<void> getUserData (BuildContext context) async {
    CollectionReference keysRef = FirebaseFirestore.instance.collection('keys');
    CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

    DocumentSnapshot keyDoc = await keysRef.doc("ecount").get();
    apiKey = keyDoc["key"];
    sessionId = keyDoc["sess_id"];
    DocumentSnapshot numberDoc = await keysRef.doc("number").get();
    csNumber = numberDoc["number"];
    kakaoLink = numberDoc["kakao"];

    user = UserData(
      id: "",
      stage: 0,
      invitations: 0,
      name: "User",
      userName: "",
      phoneNumber: "",
      email: "",
      address: "",
      addressDetails: "",
    );

    if (FirebaseAuth.instance.currentUser != null) {
      QuerySnapshot snapshot = await usersRef.where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
      if (snapshot.docs.isEmpty) {
        await app.mApp.buildErrorDialog(context, app.mResource.strings.eHomeCheckInternet);
        app.mPage.prevPage();
        return;
      }
      user = UserData(
        id: snapshot.docs[0].id,
        stage: snapshot.docs[0]["stage"],
        invitations: snapshot.docs[0]["invitations"],
        name: snapshot.docs[0]["name"],
        userName: snapshot.docs[0]["userName"],
        phoneNumber: snapshot.docs[0]["phoneNumber"],
        email: snapshot.docs[0]["email"],
        address: snapshot.docs[0]["address"],
        addressDetails: snapshot.docs[0]["addressDetails"],
        cart: Cart(itemIds: snapshot.docs[0]["cart"].cast<String>(), sizes: snapshot.docs[0]["cartSizes"].cast<int>()),
      );
    }

    await getOrder();
  }

  Future<void> updateAddress () async {
    CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

    await usersRef.doc(user!.id).update(
        {
          "address": user!.address,
          "addressDetails": user!.addressDetails,
        }
    );
  }

  Future<void> updateCart () async {
    CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

    user!.cart!.itemIds = [];
    user!.cart!.sizes = [];
    for (int i = 0; i < user!.cart!.items!.length; i++) {
      user!.cart!.itemIds!.add(user!.cart!.items![i].id);
      user!.cart!.sizes!.add(user!.cart!.items![i].selected);
    }

    await usersRef.doc(user!.id).update(
      {
        "cart": user!.cart!.itemIds!,
        "cartSizes": user!.cart!.sizes!,
      }
    );
  }

  Future<void> emptyCart () async {
    CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

    await usersRef.doc(user!.id).update(
        {
          "cart": [],
          "cartSizes": [],
        }
    );
  }

  Future<bool> numberInUse (String number) async {
    CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
    CollectionReference invitationsRef = FirebaseFirestore.instance.collection('invitations');

    QuerySnapshot snapshot = await usersRef.where("phoneNumber", isEqualTo: number).get();
    if (snapshot.docs.isNotEmpty) {
      return false;
    }
    snapshot = await invitationsRef.where("target", isEqualTo: number).get();
    if (snapshot.docs.isNotEmpty) {
      return false;
    }
    return true;
  }

  Future<void> getCalendarData (int y, int m) async {
    calendar = CalendarData(m);

    CollectionReference timeslotsRef = FirebaseFirestore.instance.collection('dates');

    DocumentSnapshot document = await timeslotsRef.doc("${y * 100 + m}").get();
    Month month = Month(
      year: (m == 1) ? y - 1 : y,
      month: (m == 1) ? 12 : m - 1,
    );
    List<Timeslot> listDays = [];
    calendar!.setPrev(month);

    month = Month(
      year: y,
      month: m,
    );
    listDays = [];
    for (int i = 1; i < document["slots"].length + 1; i++) {
      listDays.add(
        Timeslot(
          year: y,
          month: m,
          day: i,
          weekday: (((i + document["start"] - 1) % 7)).toInt(),
          available: document["available"][i.toString()],
          slots: document["slots"][i.toString()].cast<String>(),
        ),
      );
    }
    month.setDays(listDays);
    calendar!.setCurrent(month);

    month = Month(
      year: (m == 12) ? y + 1 : y,
      month: (m == 12) ? 1 : (m + 1),
    );
    calendar!.setNext(month);
  }

  Future<void> getProductData () async {
    CollectionReference productsRef = FirebaseFirestore.instance.collection('products');

    DocumentSnapshot doc = await productsRef.doc("!index").get();
    productIds = [...user!.cart!.itemIds!];
    List temp = doc["ids"].cast<String>();
    for (int i = 0; i < temp.length; i++) {
      if (!productIds!.contains(temp[i])){
        productIds!.add(temp[i]);
      }
    }
    products = [];
    user!.cart!.items = [];

    return;
  }

  Future<void> getAllProducts () async {
    futures = [];
    for (int i = 0; i < productIds!.length; i++) {
      Future<Product> tmp;
      if (i == 0) {
        tmp = Future<Product>(() async {
          Product prod = await getProduct(i);
          return prod;
        });
      }
      else {
        tmp = Future<Product>(() async {
          await futures[i-1];
          Product prod = await getProduct(i);
          return prod;
        });
      }
      futures.add(
        tmp
      );
    }
  }

  Future<Product> getProduct (int index) async {
    CollectionReference productsRef = FirebaseFirestore.instance.collection('products');

    DocumentSnapshot doc = await productsRef.doc(productIds![index]).get();
    Product product = Product(
      id: doc.id,
      name: doc["name"],
      brand: doc["brand"],
      priceOld: int.parse(doc["priceOld"]),
      price: int.parse(doc["price"]),
      thumbnail: doc["thumbnail"],
      details: doc["details"].cast<String>(),
      more: doc["more"].cast<String>(),
      images: doc["images"].cast<String>(),
      sizes: doc["sizes"].cast<String>(),
      links: doc["links"].cast<String>(),
    );

    await product.getStock();

    product.images.add(app.mResource.strings.lDetails);
    product.images.add(app.mResource.strings.lMore);

    if (user!.cart!.itemIds!.contains(product.id)) {
      product.selected = user!.cart!.sizes![user!.cart!.itemIds!.indexOf(product.id)];
      user!.cart!.items!.add(product);
    }
    products!.add(product);

    return product;
  }

  Future<void> getOrderItemData () async {
    await getOrder();
    CollectionReference selectionsRef = FirebaseFirestore.instance.collection('orders');
    CollectionReference productsRef = FirebaseFirestore.instance.collection('products');
    Directory appImgDir = await getApplicationDocumentsDirectory();

    DocumentSnapshot document = await selectionsRef.doc(app.mData.user!.id).get();
    List<DocumentSnapshot> listProducts = [];
    for (int i = 0; i < document["items"].length; i++) {
      listProducts.add(await productsRef.doc(document["items"][i]).get());
    }

    products = [];
    for (int i = 0; i < listProducts.length; i++) {
      products!.add(
        Product(
          id: listProducts[i].id,
          name: listProducts[i]["name"],
          brand: listProducts[i]["brand"],
          priceOld: int.parse(listProducts[i]["priceOld"]),
          price: int.parse(listProducts[i]["price"]),
          details: listProducts[i]["details"].cast<String>(),
          more: listProducts[i]["more"].cast<String>(),
          images: listProducts[i]["images"].cast<String>(),
          sizes: listProducts[i]["sizes"].cast<String>(),
          links: listProducts[i]["links"].cast<String>(),
          thumbnail: listProducts[i]["thumbnail"],
        ),
      );
      products![i].images.add(app.mResource.strings.lDetails);
      products![i].images.add(app.mResource.strings.lMore);
    }
    chosen = [...products!];
  }

  Future<void> getReceiptData () async {
    CollectionReference receiptsRef = FirebaseFirestore.instance.collection('receipts');
    CollectionReference productsRef = FirebaseFirestore.instance.collection('products');
    Directory appImgDir = await getApplicationDocumentsDirectory();

    QuerySnapshot snapshot = await receiptsRef.where("user", isEqualTo: user!.id).orderBy("date", descending: true).get();
    DocumentSnapshot document = snapshot.docs[0];

    user!.receipt = Receipt(
      id: document.id,
      date: document["date"],
      items: document["items"].cast<String>(),
      sizes: document["sizes"],
    );

    List<DocumentSnapshot> listProducts = [];
    for (int i = 0; i < document["items"].length; i++) {
      listProducts.add(await productsRef.doc(document["items"][i]).get());
    }

    products = [];
    for (int i = 0; i < listProducts.length; i++) {
      products!.add(
        Product(
          id: listProducts[i].id,
          name: listProducts[i]["name"],
          brand: listProducts[i]["brand"],
          priceOld: int.parse(listProducts[i]["priceOld"]),
          price: int.parse(listProducts[i]["price"]),
          details: listProducts[i]["details"].cast<String>(),
          more: listProducts[i]["more"].cast<String>(),
          images: listProducts[i]["images"].cast<String>(),
          sizes: listProducts[i]["sizes"].cast<String>(),
          links: listProducts[i]["links"].cast<String>(),
          thumbnail: listProducts[i]["thumbnail"],
        ),
      );
      products![i].images.add(app.mResource.strings.lDetails);
      products![i].images.add(app.mResource.strings.lMore);
    }

  }

  Future<void> getOrder () async {
    if (user!.stage > 0) {
      CollectionReference ordersRef = FirebaseFirestore.instance.collection('orders');

      QuerySnapshot snapshot = await ordersRef.orderBy('date').where('user', isEqualTo: user!.id).get();
      user!.order = Order(
        id: snapshot.docs[0].id,
        year: int.parse(snapshot.docs[0]["date"].toString().substring(0, 4)),
        month: int.parse(snapshot.docs[0]["date"].toString().substring(4, 6)),
        day: int.parse(snapshot.docs[0]["date"].toString().substring(6, 8)),
        timeslot: snapshot.docs[0]["slot"],
        items: snapshot.docs[0]["items"].cast<String>(),
        sizes: snapshot.docs[0]["sizes"],
      );
    }
  }

  Future<void> createReceipt () async {
    CollectionReference receiptsRef = FirebaseFirestore.instance.collection('receipts');

    List<String> items = [];
    Map<dynamic, dynamic> sizes = {};
    for (int i = 0; i < chosen!.length; i++) {
      items.add(chosen![i].id);
      sizes[chosen![i].id] = user!.order!.sizes[chosen![i].id];

    }
    DateTime day = DateTime.now();

    List prices = [];
    for (int j = 0; j < chosen!.length; j++) {
      prices.add((chosen![j].price * ((chosen!.length == 3) ? 0.9 : 1)).toInt());
    }

    await receiptsRef.add({
      "user": user!.id,
      "name": user!.name,
      "items": items,
      "date": (day.year * 10000 + day.month * 100 + day.day),
      "prices": prices,
      "sizes": sizes,
    });
  }

  Future<void> createOrder (Timeslot day, int slot, {List<String>? oldItems}) async {
    await updateCart();
    CollectionReference ordersRef = FirebaseFirestore.instance.collection('orders');
    CollectionReference timeslotsRef = FirebaseFirestore.instance.collection('dates');

    List<String> newItems = [];
    if (user!.cart != null && user!.cart?.items != null) {
      for (int i = 0; i < user!.cart!.items!.length; i++) {
        newItems.add(user!.cart!.items![i].id);
      }
    }

    List<String> items = oldItems ?? newItems;

    Map<dynamic, dynamic> sizes = {};
    for (int i = 0; i < user!.cart!.itemIds!.length; i++) {
      sizes[user!.cart!.itemIds![i]] = user!.cart!.items![i].sizes[user!.cart!.sizes![i]];
    }

    await ordersRef.doc(app.mData.user!.id).set({
      "date": (day.year * 10000 + day.month * 100 + day.day),
      "user": user!.id,
      "name": user!.name,
      "address": user!.address,
      "addressDetails": user!.addressDetails,
      "slot": slot,
      "items": items,
      "sizes": sizes,
    });

    DocumentSnapshot document = await timeslotsRef.doc("${day.year * 100 + day.month}").get();
    Map<dynamic, dynamic> available = document["available"];
    available[day.day.toString()] = available[day.day.toString()] - 1;
    Map<dynamic, dynamic> schedule = document["slots"];
    List<String> slots = schedule[day.day.toString()].cast<String>();
    slots[slot - 10] = user!.id;
    if (slot < 19) {
      slots[slot - 9] = user!.id;
    }
    if (slot < 18) {
      if (slots[slot - 8] == "") {
        slots[slot - 8] = user!.id;
      }
    }
    if (slot > 10) {
      slots[slot - 11] = user!.id;
    }
    if (slot > 11) {
      if (slots[slot - 12] == "") {
        slots[slot - 12] = user!.id;
      }
    }
    schedule[day.day.toString()] = slots;
    await timeslotsRef.doc("${day.year * 100 + day.month}").update({
      "slots": schedule,
      "available": available,
    });

    await emptyCart();
    await getOrder();
  }

  Future<void> changeOrder (Timeslot day, int slot) async {
    await getOrder();
    CollectionReference ordersRef = FirebaseFirestore.instance.collection('orders');
    CollectionReference timeslotsRef = FirebaseFirestore.instance.collection('dates');

    DocumentSnapshot document = await timeslotsRef.doc("${user!.order!.year * 100 + user!.order!.month}").get();
    Map<dynamic, dynamic> schedule = document["slots"];
    List<String> slots = schedule[user!.order!.day.toString()].cast<String>();
    slots[user!.order!.timeslot - 10] = "";
    if (user!.order!.timeslot < 19) {
      slots[user!.order!.timeslot - 9] = "";
    }
    if (user!.order!.timeslot > 10) {
      slots[user!.order!.timeslot - 11] = "";
    }
    if (user!.order!.timeslot > 11) {
      if (slots[user!.order!.timeslot - 12] == user!.id){
        slots[user!.order!.timeslot - 12] = "";
      }
    }
    if (user!.order!.timeslot < 18) {
      if (slots[user!.order!.timeslot - 8] == user!.id){
        slots[user!.order!.timeslot - 8] = "";
      }
    }
    schedule[user!.order!.day.toString()] = slots;
    Map<dynamic, dynamic> available = document["available"];
    available[user!.order!.day.toString()] = available[user!.order!.day.toString()] + 1;
    await timeslotsRef.doc("${user!.order!.year * 100 + user!.order!.month}").update({
      "slots": schedule,
      "available": available,
    });

    await ordersRef.doc(app.mData.user!.id).update({
      "date": (day.year * 10000 + day.month * 100 + day.day),
      "slot": slot,
    });

    document = await timeslotsRef.doc("${day.year * 100 + day.month}").get();
    available = document["available"];
    available[day.day.toString()] = available[day.day.toString()] - 1;
    schedule = document["slots"];
    slots = schedule[day.day.toString()].cast<String>();
    slots[slot - 10] = user!.id;
    if (slot < 19) {
      slots[slot - 9] = user!.id;
    }
    if (slot < 18) {
      if (slots[slot - 8] == "") {
        slots[slot - 8] = user!.id;
      }
    }
    if (slot > 10) {
      slots[slot - 11] = user!.id;
    }
    if (slot > 11) {
      if (slots[slot - 12] == "") {
        slots[slot - 12] = user!.id;
      }
    }
    schedule[day.day.toString()] = slots;
    await timeslotsRef.doc("${day.year * 100 + day.month}").update({
      "slots": schedule,
      "available": available,
    });

    await emptyCart();
    await getOrder();
  }

  Future<void> createInvitation (String number) async {
    CollectionReference invitationsRef = FirebaseFirestore.instance.collection('invitations');
    CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

    await invitationsRef.doc(number).set({
      "user": user!.id,
      "target": number,
      "date": (DateTime.now().year * 10000 + DateTime.now().month * 100 + DateTime.now().day).toString(),
    });

    app.mData.user!.invitations -= 1;

    await usersRef.doc(app.mData.user!.id).update({
      "invitations": app.mData.user!.invitations,
    });
  }

  Future<void> cancelOrder () async {
    await getOrder();
    CollectionReference ordersRef = FirebaseFirestore.instance.collection('orders');
    CollectionReference timeslotsRef = FirebaseFirestore.instance.collection('dates');

    DocumentSnapshot document = await timeslotsRef.doc("${user!.order!.year * 100 + user!.order!.month}").get();
    Map<dynamic, dynamic> schedule = document["slots"];
    List<String> slots = schedule[user!.order!.day.toString()].cast<String>();
    slots[user!.order!.timeslot - 10] = "";
    if (user!.order!.timeslot < 19) {
      slots[user!.order!.timeslot - 9] = "";
    }
    if (user!.order!.timeslot > 10) {
      slots[user!.order!.timeslot - 11] = "";
    }
    if (user!.order!.timeslot > 11) {
      if (slots[user!.order!.timeslot - 12] == user!.id){
        slots[user!.order!.timeslot - 12] = "";
      }
    }
    if (user!.order!.timeslot < 18) {
      if (slots[user!.order!.timeslot - 8] == user!.id){
        slots[user!.order!.timeslot - 8] = "";
      }
    }
    schedule[user!.order!.day.toString()] = slots;
    Map<dynamic, dynamic> available = document["available"];
    available[user!.order!.day.toString()] = available[user!.order!.day.toString()] + 1;
    await timeslotsRef.doc("${user!.order!.year * 100 + user!.order!.month}").update({
      "slots": schedule,
      "available": available,
    });

    await ordersRef.doc(user!.order!.id).delete();
  }

  Future<void> nextStage () async {
    CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

    user!.stage++;

    await usersRef.doc(user!.id).update({
      "stage": user!.stage,
    });
  }

  Future<void> prevStage () async {
    CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

    user!.stage--;

    await usersRef.doc(user!.id).update({
      "stage": user!.stage,
    });
  }

  Future<void> postOrder (List<Product> data, List<int> sizes) async {
    List params = [];
    for (int i = 0; i < data.length; i++) {
      params.add(
        {
          "Line": "0",
          "BulkDatas": {
            "IO_DATE": (DateTime.now().year * 10000 + DateTime.now().month * 100 + DateTime.now().day).toString(),
            "UPLOAD_SER_NO": "0",
            "WH_CD": "00001",
            "U_MEMO1": "주문",
            "PROD_CD": data[i].id + "_" + data[i].sizes[sizes[i]],
            "QTY": "1",
            "PRICE": "0",
          }
        },
      );
    }
    var res = await Dio().post("https://oapicc.ecount.com/OAPI/V2/Sale/SaveSale?SESSION_ID=" + sessionId, data: {
      "SaleList": params,
    });
    print(res);
  }

  Future<void> postReturn (List<Product> data, Map sizes) async {
    List params = [];
    for (int i = 0; i < data.length; i++) {
      params.add(
        {
          "Line": "0",
          "BulkDatas": {
            "IO_DATE": (DateTime.now().year * 10000 + DateTime.now().month * 100 + DateTime.now().day).toString(),
            "UPLOAD_SER_NO": "0",
            "WH_CD": "00001",
            "U_MEMO1": "주문",
            "PROD_CD": data[i].id + "_" + sizes[data[i].id],
            "QTY": "1",
            "PRICE": "0",
          }
        },
      );
    }
    var res = await Dio().post("https://oapicc.ecount.com/OAPI/V2/Purchases/SavePurchases?SESSION_ID=" + sessionId, data: {
      "PurchasesList": params,
    });
    print(res);
  }

  Future<void> getStock () async {
    CollectionReference keysRef = FirebaseFirestore.instance.collection('keys');

    DocumentSnapshot doc = await keysRef.doc("ecount").get();
    Timestamp data = doc["time"];
    DateTime date = data.toDate();

    sessionId = doc["sess_id"];

    if (date.add(const Duration(minutes: 20)).isBefore(DateTime.now())) {
      //re-check stock
      var res = await Dio().post("https://oapicc.ecount.com/OAPI/V2/InventoryBalance/GetListInventoryBalanceStatus?SESSION_ID=" + sessionId,
        data: {
          "BASE_DATE": (DateTime.now().year * 10000 + DateTime.now().month * 100 + DateTime.now().day).toString(),
          "UPLOAD_SER_NO": "0",
          "WH_CD": "00001",
        }
      );
      print(res);
      stock = res.data["Data"]["Result"];
      keysRef.doc("ecount").update({
        "stock": stock,
        "time": Timestamp.fromDate(DateTime.now()),
      });
    }
    else {
      stock = doc["stock"];
    }
  }

  Future<int> getSingleStock (String product) async {
    var res = await Dio().post("https://oapicc.ecount.com/OAPI/V2/InventoryBalance/ViewInventoryBalanceStatus?SESSION_ID=" + sessionId,
        data: {
          "BASE_DATE": (DateTime.now().year * 10000 + DateTime.now().month * 100 + DateTime.now().day).toString(),
          "UPLOAD_SER_NO": "0",
          "WH_CD": "00001",
          "PROD_CD": product,
        }
    );
    return res.data["Data"]["Result"][0]["BAL_QTY"].toInt();
  }

  Future<void> getTermsPDF () async {
    final data = await rootBundle.load("assets/pdfs/terms.pdf");
    final bytes = data.buffer.asUint8List();

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/terms.pdf");
    await file.writeAsBytes(bytes, flush: true);
    terms = file;
  }

  Future<void> getPolicyPDF () async {
    final data = await rootBundle.load("assets/pdfs/policy.pdf");
    final bytes = data.buffer.asUint8List();

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/policy.pdf");
    await file.writeAsBytes(bytes, flush: true);
    policy = file;
  }
}