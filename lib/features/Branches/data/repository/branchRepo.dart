import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/branchModel.dart';

class BranchRepository {
  final FirebaseFirestore _firestore;

  BranchRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final String _collection = 'branches';

  Future<void> addBranch(BranchModel branch) async {
    await _firestore.collection(_collection).add(branch.toJson());
  }

  Future<void> updateBranch(String branchId, BranchModel updatedBranch) async {
    await _firestore.collection(_collection).doc(branchId).update(updatedBranch.toJson());
  }

  Future<void> deleteBranch(String branchId) async {
    await _firestore.collection(_collection).doc(branchId).delete();
  }

  Stream<List<BranchModel>> getBranches() {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return BranchModel.fromJson(data,doc.id);
      }).toList();
    });
  }

  Future<BranchModel?> getBranchById(String branchId) async {
    final doc = await _firestore.collection(_collection).doc(branchId).get();
    if (doc.exists && doc.data() != null) {
      return BranchModel.fromJson(doc.data()!,doc.id);
    }
    return null;
  }
}
