import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  const ChatScreen({Key? key}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;

  String messageText = '';
  final messageTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print(DateTime.now());
    getCurrentUser();

  }

  void getCurrentUser() {
    try{
      final user = _auth.currentUser;
      if(user != null)
      {
        loggedInUser = user;
        // print(loggedInUser.email);
      }
    }
    catch(e) {
      rethrow;
    }
  }

  // void getMessages() async{
  //   final messages = await _firestore.collection('messages').get();
  //   for(var mes in messages.docs)
  //     {
  //       print(mes.data());
  //     }
  // }

  // void messageStream() async{
  //   await for(var snapshot in _firestore.collection('messages').snapshots())
  //     {
  //       for(var message in snapshot.docs)
  //         {
  //           // print(message.data());
  //         }
  //     }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: ()=>Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios,color: Colors.black54,)),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        centerTitle: true,
        title: const Text('⚡️Chat'),
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
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // dynamic currentTime = DateFormat.Hms().format(DateTime.now());
                      // print(DateFormat('kk:mm:ss').format(DateTime.now()));
                      // print("current time: " + currentTime);
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                        'time' : DateFormat.jm().format(DateTime.now()),
                      });
                    },
                    child: const Text(
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
  const MessagesStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context,snapshot){
        List<MessageBubble> messageWidgets = [];
        if(!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator()
          );
        }
        final messages = snapshot.data?.docs.reversed;
        for(var message in messages!){
          final messageSender = message.get('sender');
          final messageText = message.get('text');
          final messageTime = message.get('time');
          var currentUser = loggedInUser.email;

          messageWidgets.add(MessageBubble(
            sender: messageSender,
            text: messageText,
            time: messageTime,
            isMe:currentUser == messageSender ,)
          );
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}


// ignore: must_be_immutable
class MessageBubble extends StatelessWidget {

  String text;
  String sender;
  var time ;
  bool isMe;

  MessageBubble({Key? key, required this.sender,required this.text,required this.isMe,required this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12.0,
            ),
          ),
          Material(
            elevation: 5.0,
            borderRadius:  isMe? const BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)
            ): const BorderRadius.only(
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)
            ),
            color: isMe? Colors.lightBlueAccent : Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: isMe? Colors.white : Colors.black,
                  ),
                ),
              )
          ),
          Text(time,style: TextStyle(color: Colors.black54,fontSize: 12),)
        ],
      ),
    );
  }
}

