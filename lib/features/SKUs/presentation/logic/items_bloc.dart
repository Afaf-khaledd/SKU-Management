import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/skuModel.dart';
import '../../data/repository/skuRepo.dart';
import 'items_event.dart';
import 'items_state.dart';

class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  final SKURepository itemsRepository;

  ItemsBloc({required this.itemsRepository}) : super(SKUInitial()) {
    on<LoadSKUs>(_onLoadSKUs);
    on<GetItemById>(_onGetItemSKUs);
    on<AddSKU>(_onAddSKU);
    on<UpdateSKU>(_onUpdateSKU);
    on<DeactivateSKU>(_onDeactivateSKU);
  }

  Future<void> _onLoadSKUs(LoadSKUs event, Emitter<ItemsState> emit) async {
    emit(SKULoading());
    try {
      final stream = itemsRepository.getItems();
      await emit.forEach<List<SKUModel>>(
        stream,
        onData: (items) => SKULoaded(items),
        onError: (_, __) => SKUFailure("Failed to fetch branches."),
      );
    } catch (e) {
      emit(SKUFailure('Failed to load items: $e'));
    }
  }

  Future<void> _onGetItemSKUs(GetItemById event, Emitter<ItemsState> emit) async {
    emit(SKULoading());
    try {
      emit(SKULoading());
      final item = await itemsRepository.getItemById(event.itemId);
      if (item != null) {
        emit(SKUItemLoaded(item));
      } else {
        emit(SKUFailure('Item not found.'));
      }
    } catch (e) {
      emit(SKUFailure('Failed to load item: $e'));
    }
  }

  Future<void> _onAddSKU(AddSKU event, Emitter<ItemsState> emit) async {
    emit(SKULoading());
    try {
      await itemsRepository.addItem(event.sku);
      emit(SKUOperationSuccess());
    } catch (e) {
      emit(SKUFailure('Failed to add SKU: $e'));
    }
  }

  Future<void> _onUpdateSKU(UpdateSKU event, Emitter<ItemsState> emit) async {
    emit(SKULoading());
    try {
      await itemsRepository.updateItem(event.skuId, event.updatedSKU);
      emit(SKUOperationSuccess());
    } catch (e) {
      emit(SKUFailure('Failed to update SKU: $e'));
    }
  }

  Future<void> _onDeactivateSKU(DeactivateSKU event, Emitter<ItemsState> emit) async {
    emit(SKULoading());
    try {
      await itemsRepository.deactivateItem(event.skuId, event.state);
      final stream = itemsRepository.getItems();
      await emit.forEach<List<SKUModel>>(
        stream,
        onData: (items) => SKULoaded(items),
        onError: (_, __) => SKUFailure("Failed to fetch branches."),
      );
      emit(SKUOperationSuccess());
    } catch (e) {
      emit(SKUFailure('Failed to deactivate SKU: $e'));
    }
  }
}