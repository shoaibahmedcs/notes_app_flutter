import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'notes';

  // Get notes for a specific user
  Stream<List<Note>> getNotesStream(String userId) {
    print('Getting notes for user: $userId'); // Debug log

    // First try without ordering to see if we get any data
    return _firestore
        .collection(collection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          print('Received ${snapshot.docs.length} documents'); // Debug log
          List<Note> notes = [];
          for (var doc in snapshot.docs) {
            try {
              print('Document ID: ${doc.id}, Data: ${doc.data()}'); // Debug log
              notes.add(Note.fromFirestore(doc));
            } catch (e) {
              print('Error parsing document ${doc.id}: $e');
            }
          }
          // Sort in memory instead of using Firestore orderBy
          notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          return notes;
        });
  }

  // Add a new note
  Future<void> addNote(Note note) async {
    try {
      print('Adding note: ${note.toMap()}'); // Debug log
      DocumentReference docRef = await _firestore
          .collection(collection)
          .add(note.toMap());
      print('Note added with ID: ${docRef.id}'); // Debug log
    } catch (e) {
      print('Error adding note: $e');
      rethrow;
    }
  }

  // Update an existing note
  Future<void> updateNote(Note note) async {
    try {
      await _firestore.collection(collection).doc(note.id).update(note.toMap());
    } catch (e) {
      print('Error updating note: $e');
      rethrow;
    }
  }

  // Delete a note
  Future<void> deleteNote(String noteId) async {
    try {
      await _firestore.collection(collection).doc(noteId).delete();
    } catch (e) {
      print('Error deleting note: $e');
      rethrow;
    }
  }

  // Get a single note by ID
  Future<Note?> getNoteById(String noteId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(collection)
          .doc(noteId)
          .get();

      if (doc.exists) {
        return Note.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting note: $e');
      return null;
    }
  }
}
