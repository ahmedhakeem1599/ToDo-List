class TaskModel {
  final String task;
  final bool isDone;
  final String id; // userId
  final String docId; // document ID from Firestore

  TaskModel(this.task, this.isDone, this.id, this.docId);
}