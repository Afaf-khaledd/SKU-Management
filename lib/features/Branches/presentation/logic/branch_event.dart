import 'package:equatable/equatable.dart';
import '../../data/model/branchModel.dart';

abstract class BranchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchBranches extends BranchEvent {}

class AddBranch extends BranchEvent {
  final BranchModel branch;

  AddBranch(this.branch);

  @override
  List<Object?> get props => [branch];
}

class UpdateBranch extends BranchEvent {
  final String id;
  final BranchModel updatedBranch;

  UpdateBranch({required this.id, required this.updatedBranch});

  @override
  List<Object?> get props => [id, updatedBranch];
}

class DeleteBranch extends BranchEvent {
  final String id;

  DeleteBranch(this.id);

  @override
  List<Object?> get props => [id];
}
