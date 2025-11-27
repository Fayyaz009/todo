import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference _firestore = FirebaseFirestore.instance.collection(
    'users',
  );

  Stream<List<Map<String, dynamic>>> loadTodo(String userId) async* {
    try {
      await for (QuerySnapshot snapshot
          in _firestore
              .doc(userId)
              .collection('todos')
              .orderBy('createdAt', descending: true)
              .snapshots()) {
        List<Map<String, dynamic>> todos = [];
        for (QueryDocumentSnapshot doc in snapshot.docs) {
          Map<String, dynamic> todoData = doc.data() as Map<String, dynamic>;
          todoData['id'] = doc.id; // Document ID for delete/update
          todoData['docId'] = doc.id; // Extra for UI consistency

          if (todoData['createdAt'] != null) {
            DateTime dateTime = (todoData['createdAt'] as Timestamp).toDate();

            // Simple format without package: "dd/MM/yyyy, HH:mm"
            String formatted =
                '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}, ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

            todoData['createdAt'] = formatted; // UI mein yeh use kar
          }
          todos.add(todoData);
        }
        yield todos; // Har snapshot pe fresh list yield – real-time magic! 🎉
      }
    } catch (error) {
      yield []; // Error pe empty list, UI crash nahi hoga
    }
  }

  Future<String> authSignIn() async {
    try {
      await auth.signInAnonymously();
      String id = auth.currentUser!.uid;
      return id;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> authSignOut() async {
    try {
      await auth.signOut();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addTodo(String userId, String title) async {
    try {
      await _firestore.doc(userId).collection('todos').add({
        'title': title,
        'id': '',
        'createdAt': Timestamp.now(),
        'isComplete': false,
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateTodo(String userId, String docId, String title) async {
    try {
      await _firestore.doc(userId).collection('todos').doc(docId).update({
        'title': title,
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteTodo(String userUid, String docId) async {
    try {
      await _firestore.doc(userUid).collection('todos').doc(docId).delete();
    } catch (error) {
      rethrow;
    }
  }

  Future<String> authSignInwithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential currentUser = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      String userId = currentUser.user!.uid;
      return userId;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> toggleTodo(String userId, String docId, bool toggle) async {
    try {
      await _firestore.doc(userId).collection('todos').doc(docId).update({
        'isComplete': toggle,
      });
    } catch (error) {
      rethrow;
    }
  }
}
