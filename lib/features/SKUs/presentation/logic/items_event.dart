import 'package:equatable/equatable.dart';
import '../../data/model/skuModel.dart';

abstract class ItemsEvent extends Equatable {
  const ItemsEvent();
  @override
  List<Object?> get props => [];
}

class LoadSKUs extends ItemsEvent {}

class GetItemById extends ItemsEvent {
  final String itemId;

  const GetItemById(this.itemId);
}

class AddSKU extends ItemsEvent {
  final SKUModel sku;

  const AddSKU(this.sku);

  @override
  List<Object?> get props => [sku];
}

class UpdateSKU extends ItemsEvent {
  final String skuId;
  final SKUModel updatedSKU;

  const UpdateSKU(this.skuId, this.updatedSKU);

  @override
  List<Object?> get props => [skuId, updatedSKU];
}

class DeactivateSKU extends ItemsEvent {
  final String skuId;
  final bool state;

  const DeactivateSKU(this.skuId,this.state);

  @override
  List<Object?> get props => [skuId, state];
}