import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService{

  Future<String> createMessage(String accountID, String shopID, String content)async{
    String retV= 'err';
    try{
      CollectionReference refAccount = Firestore.instance.collection("users").document(accountID).collection("messages").document(shopID).collection("chattingroom");
      DocumentReference documentAccount = refAccount.document();
      documentAccount.setData({
        'user' : shopID,
        'content' : content,
        'timeStamp' : Timestamp.now(),
        'isSend' : true,
      });
      CollectionReference refShop = Firestore.instance.collection("users").document(shopID).collection("messages").document(accountID).collection("chattingroom");
      DocumentReference document = refShop.document();
      document.setData({
        'user' : accountID,
        'content' : content,
        'timeStamp' : Timestamp.now(),
        'isSend' : false,
      });
      retV = 'success';
    }
    catch(e){
    }
    return retV;
  }
  getAllMess(String accountId, String shopID){
    return Firestore.instance.collection('users').document(accountId).collection('messages').document(shopID).collection("chattingroom").orderBy('timeStamp', descending: false)
        .getDocuments();
  }
}