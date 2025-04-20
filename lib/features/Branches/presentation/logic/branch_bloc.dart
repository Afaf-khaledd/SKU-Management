import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/branchModel.dart';
import '../../data/repository/branchRepo.dart';
import 'branch_event.dart';
import 'branch_state.dart';

class BranchBloc extends Bloc<BranchEvent, BranchState> {
  final BranchRepository branchRepository;

  BranchBloc({required this.branchRepository}) : super(BranchInitial()) {
    on<FetchBranches>(_onFetchBranches);
    on<AddBranch>(_onAddBranch);
    on<UpdateBranch>(_onUpdateBranch);
    on<DeleteBranch>(_onDeleteBranch);
  }

  Future<void> _onFetchBranches(FetchBranches event, Emitter<BranchState> emit) async {
    emit(BranchLoading());
    try {
      final stream = branchRepository.getBranches();
      await emit.forEach<List<BranchModel>>(
        stream,
        onData: (branches) => BranchLoaded(branches),
        onError: (_, __) => BranchError("Failed to fetch branches."),
      );
    } catch (e) {
      emit(BranchError(e.toString()));
    }
  }

  Future<void> _onAddBranch(AddBranch event, Emitter<BranchState> emit) async {
    try {
      await branchRepository.addBranch(event.branch);
      emit(BranchOperationSuccess());
    } catch (e) {
      emit(BranchError(e.toString()));
    }
  }

  Future<void> _onUpdateBranch(UpdateBranch event, Emitter<BranchState> emit) async {
    try {
      await branchRepository.updateBranch(event.id, event.updatedBranch);
      emit(BranchOperationSuccess());
    } catch (e) {
      emit(BranchError(e.toString()));
    }
  }

  Future<void> _onDeleteBranch(DeleteBranch event, Emitter<BranchState> emit) async {
    try {
      await branchRepository.deleteBranch(event.id);
      final stream = branchRepository.getBranches();
      await emit.forEach<List<BranchModel>>(
        stream,
        onData: (branches) => BranchLoaded(branches),
        onError: (_, __) => BranchError("Failed to fetch branches."),
      );
      emit(BranchOperationSuccess());
    } catch (e) {
      emit(BranchError(e.toString()));
    }
  }
}
