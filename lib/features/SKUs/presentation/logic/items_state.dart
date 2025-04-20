import 'package:equatable/equatable.dart';
import '../../data/model/skuModel.dart';

abstract class ItemsState extends Equatable {
  const ItemsState();
  @override
  List<Object?> get props => [];
}

class SKUInitial extends ItemsState {}

class SKULoading extends ItemsState {}

class SKULoaded extends ItemsState {
  final List<SKUModel> items;

  const SKULoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class SKUItemLoaded extends ItemsState {
  final SKUModel item;

  const SKUItemLoaded(this.item);

  @override
  List<Object?> get props => [item];
}

class SKUOperationSuccess extends ItemsState {}

class SKUFailure extends ItemsState {
  final String message;

  const SKUFailure(this.message);

  @override
  List<Object?> get props => [message];
}