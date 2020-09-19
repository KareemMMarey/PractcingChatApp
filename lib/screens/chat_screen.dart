import 'package:flutter/material.dart';
import 'package:flutterappfirebasepractice/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

final _fireStore = Firestore.instance;
FirebaseUser loggedInUser;
class ChatScreen extends StatefulWidget {
  static const String id='chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextEditingController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String messageText;
  void getCurrentUser() async{
    try{
      var user =await _auth.currentUser();
      if(user != null){
        loggedInUser = user;
        //print(loggedInUser.email);
      }
//      else{
//        Navigator.pushNamed(context, LoginScreen.id);
//      }
    }
    catch(e){
      print(e);
    }

  }
//  void getUserMessages() async{
//    try{
//      final messages = await _fireStore.collection('messages').getDocuments();
//      for(DocumentSnapshot message in messages.documents){
//        print(message.data);
//      }
//    }
//    catch(e){print(e);}
//  }
  void getMessagesStream() async{
    try{
      //Here is subscription to listen to any changes happens in the messages collection
      //To get messages instantly
      await for (var snapshot in _fireStore.collection('messages').snapshots()){
        for(DocumentSnapshot message in snapshot.documents){
          print(message.data);
        }
      }

    }
    catch(e){print(e);}
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //getMessagesStream();
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextEditingController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      messageTextEditingController.clear();
                      //Implement send functionality.
                      try{
                        await _fireStore.collection('messages').add({
                          'text': messageText,
                          'sender': loggedInUser.email
                        });
                        //print('you are done');
                      }
                      catch(e){
                        print(e);
                      }
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore.collection('messages').snapshots(),
      builder: (context, snapshot){
        List<MessageBubble> messageBubbles = [];

        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.documents.reversed;

        for(var messge in messages){
          final messageText =messge.data['text'];
          final messagesender =messge.data['sender'];
          final currentUser = loggedInUser.email;
          final messageBubble = MessageBubble(
            text: messageText,
            sender: messagesender,
            isMe: currentUser == messagesender,);
          messageBubbles.add(messageBubble);
        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.text,this.sender,this.isMe});
  final bool isMe;
  final String sender;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        //Align to left or right
        crossAxisAlignment:isMe? CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: <Widget>[
          Text(sender,
        style: TextStyle(
            color: Colors.black54,
            fontSize: 12.0),),
          Material(
            //Add some shadow
            elevation: 5.0,
            //Add radious around the message
            borderRadius:isMe? BorderRadius.only(topLeft: Radius.circular(30.0), bottomLeft: Radius.circular(30.0) ,
                bottomRight: Radius.circular(30.0)):
            BorderRadius.only(topRight: Radius.circular(30.0), bottomLeft: Radius.circular(30.0) ,
                bottomRight: Radius.circular(30.0)),
            color: isMe?Colors.lightBlueAccent:Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(text,
                style: TextStyle(
                    color: isMe?Colors.white:Colors.black54,
                    fontSize: 15.0),),
            ),
          ),
        ],
      ),
    );
  }
}
