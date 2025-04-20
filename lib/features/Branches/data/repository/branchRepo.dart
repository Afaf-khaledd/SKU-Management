import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/branchModel.dart';

class BranchRepository {
  final FirebaseFirestore _firestore;

  BranchRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final String _collection = 'branches';

  Future<void> addBranch(BranchModel branch) async {
    try {
      await _firestore.collection(_collection).add(branch.toJson());
    } catch (e) {
      throw Exception('Error adding branch: $e');
    }
  }
  Future<void> updateBranch(String branchId, BranchModel updatedBranch) async {
    try {
      await _firestore.collection(_collection).doc(branchId).update(updatedBranch.toJson());
    } catch (e) {
      throw Exception('Error updating branch: $e');
    }
  }

  Future<void> deleteBranch(String branchId) async {
    try {
      await _firestore.collection(_collection).doc(branchId).delete();
    } catch (e) {
      throw Exception('Error deleting branch: $e');
    }
  }

  Stream<List<BranchModel>> getBranches() {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return BranchModel.fromJson(data, doc.id);
      }).toList();
    }).handleError((error) {
      throw Exception('Error fetching branches: $error');
    });
  }

  Future<BranchModel?> getBranchById(String branchId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(branchId).get();
      if (doc.exists && doc.data() != null) {
        return BranchModel.fromJson(doc.data()!, doc.id);
      }
    } catch (e) {
      throw Exception('Error fetching branch by ID: $e');
    }
    return null;
  }
}
