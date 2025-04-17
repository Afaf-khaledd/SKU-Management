import 'package:equatable/equatable.dart';

import '../../data/model/branchModel.dart';

abstract class BranchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BranchInitial extends BranchState {}

class BranchLoading extends BranchState {}

class BranchLoaded extends BranchState {
  final List<BranchModel> branches;

  BranchLoaded(this.branches);

  @override
  List<Object?> get props => [branches];
}

class BranchOperationSuccess extends BranchState {}

class BranchError extends BranchState {
  final String message;

  BranchError(this.message);

  @override
  List<Object?> get props => [message];
}
