import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sku/features/SKUs/data/model/skuModel.dart';

class SKURepository {
  final FirebaseFirestore _firestore;

  SKURepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final String _collection = 'items';

  Future<void> addItem(SKUModel item) async {
    try {
      await _firestore.collection(_collection).add(item.toJson());
    } catch (e) {
      throw Exception('Error adding item: $e');
    }
  }

  Future<void> updateItem(String itemId, SKUModel updatedItem) async {
    try {
      await _firestore.collection(_collection).doc(itemId).update(updatedItem.toJson());
    } catch (e) {
      throw Exception('Error updating item: $e');
    }
  }

  Future<void> deactivateItem(String itemId, bool state) async {
    await _firestore.collection(_collection).doc(itemId).update({'isActive': state});
  }

  Stream<List<SKUModel>> getItems() {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return SKUModel.fromJson(data, doc.id);
      }).toList();
    }).handleError((error) {
      throw Exception('Error fetching items: $error');
    });
  }
  Future<SKUModel?> getItemById(String itemId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(itemId).get();
      if (doc.exists && doc.data() != null) {
        return SKUModel.fromJson(doc.data()!, doc.id);
      }
    } catch (e) {
      throw Exception('Error fetching item by ID: $e');
    }
    return null;
  }
}
