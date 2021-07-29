import 'package:chat_app_project_jieqing/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = new TextEditingController();
  final _auth = FirebaseAuth.instance;
  late String messageText;

  @override
  void initState() {
    // implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    // Check if there's a current user who signed in
    try {
      final user = _auth.currentUser;
      loggedInUser = user!;
      print(loggedInUser.email);
    } catch (e) {
      print(e);
    }
  }

  /// Getting all the documents inside 'messages' collection, print out what we need
  /// This is a Future snapshot
  void getMessages() async {
    final messages = await _firestore
        .collection('messages')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        // print(doc['sender'] + '--------' +doc['text']);
        // print(doc.data());
        print(doc['text']);
      });
    });
  }

  /// Listen to the Streaming, all of the changes, of Firebase collection
  /// We will get notified, when new data coming through
  void messagesStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data);
      }
      print('-------------------------------------');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
      ),
      body: SafeArea(
        child: Container(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

              MessagesStream(),

              Column(
                children: [
                  TextField(
                    controller: messageTextController,
                    onChanged: (value) {
                      messageText = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Type your message here...',
                      contentPadding: EdgeInsets.all(10.0),
                    ),
                  ),
                  TextButton(
                    child: Text(
                      'Send',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    onPressed: () async {
                      messageTextController.clear(); // Clear the input text on screen after click send
                      // Set up on Firebase, note that the add method is expecting a Map type

                      await _firestore.collection('messages').add({
                        'time': DateTime.now(),
                        'text': messageText,
                        'sender': loggedInUser.email,
                      });
                      // getMessages(); // Previously tested here
                      messagesStream();
                    },
                  ),
                  TextButton(
                      onPressed: () {
                        // Go to Login Screen
                        _auth.signOut();
                        Navigator.pushNamed(context, WelcomeScreen.id);
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // stream: _firestore.collection('messages').orderBy('time', descending: false).snapshots(),

      stream: _firestore.collection('messages').snapshots(),
      // Where the data gonna come from
      /// Provide the logic that what the builder will actually do
      /// Update the list of messages, rebuild all the children of the String Builder, here the columns of the widgets
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        /// Here, async snapshot contains a query snapshot from Firebase
        /// Access the query snapshot through the data property, gives us a list of document snapshots
        final messages = snapshot.data!.docs.reversed;
        List<MessageBubble> messageBubbles = [];

        for (var message in messages) {
          final messageText = message.get('text');
          final messageSender = message.get('sender');
          final messageTime = message.get('time');
          final currentUser = loggedInUser.email;

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender, // The message is from the loggin user
            time: messageTime,
          );
          messageBubbles.add(messageBubble);
          messageBubbles.sort((a , b ) => b.time.compareTo(a.time));

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

  MessageBubble({required this.sender, required this.text, required this.isMe, required this.time});

  final String sender;
  final String text;
  final bool isMe;
  final Timestamp time;

  @override
  Widget build(BuildContext context) {
    /// ListView is fully loaded on screen, return the new message bubble
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '$sender  +  ${time.toDate()}' ,
            style: TextStyle(
              fontSize: 15.0,
            ),
          ),
          Material(
            borderRadius: BorderRadius.only(
              topLeft: isMe ? Radius.circular(30.0) : Radius.circular(0.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
              topRight: isMe ? Radius.circular(0.0) : Radius.circular(30.0)
            ),
            color: isMe ? Colors.blue: Colors.white70,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white: Colors.black,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
