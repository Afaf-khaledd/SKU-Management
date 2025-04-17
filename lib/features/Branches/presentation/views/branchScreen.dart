import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sku/core/components/customMainButton.dart';
import 'package:sku/core/helper/input_validators.dart';
import 'package:sku/core/utils/colors.dart';
import 'package:sku/features/Branches/data/model/branchModel.dart';

import '../../../../core/components/customWhiteTextField.dart';
import '../logic/branch_bloc.dart';
import '../logic/branch_event.dart';
import '../logic/branch_state.dart';

class BranchScreen extends StatefulWidget {
  final BranchModel? branch;

  const BranchScreen({super.key, required this.branch});

  @override
  State<BranchScreen> createState() => _BranchScreenState();
}

class _BranchScreenState extends State<BranchScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _managerController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.branch != null) {
      _nameController.text = widget.branch!.name;
      _locationController.text = widget.branch!.location;
      _managerController.text = widget.branch!.managerName;
      _phoneController.text = widget.branch!.phone;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _managerController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String screenTitle = widget.branch == null ? "Add Branch" : "Update Branch";

    return Scaffold(
      appBar: AppBar(
        title: Text('Branch Management',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 25),
        ),
        leading: IconButton(onPressed: ()=> context.pop(), icon: Icon(Icons.arrow_back_ios_rounded)),
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
      ),

      body: BlocListener<BranchBloc, BranchState>(
        listener: (context, state) {
          if (state is BranchError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          } else if (state is BranchOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Branch operation successful')),
            );
            context.read<BranchBloc>().add(FetchBranches());
            context.pop();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  screenTitle,
                  style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600,color: Colors.grey[800]),
                ),
                const SizedBox(height: 45),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomWhiteTextField(
                        controller: _nameController,
                        hintText: 'Branch Name',
                        icon: Icons.business_outlined,
                        validator: InputValidators.validateName,
                      ),
                      const SizedBox(height: 25),

                      CustomWhiteTextField(
                        controller: _locationController,
                        hintText: 'Location eg..Cairo, Egypt',
                        icon: Icons.map_outlined,
                        validator: InputValidators.validateLocation,
                      ),
                      const SizedBox(height: 25),

                      CustomWhiteTextField(
                        controller: _managerController,
                        hintText: 'Manager Name',
                        icon: Icons.person_outline,
                        validator: InputValidators.validateManagerName,
                      ),
                      const SizedBox(height: 25),

                      CustomWhiteTextField(
                        controller: _phoneController,
                        hintText: 'Phone',
                        icon: Icons.phone_outlined,
                        validator: InputValidators.validatePhone,
                      ),
                      const SizedBox(height: 50),

                      BlocBuilder<BranchBloc, BranchState>(
                        builder: (context, state) {
                          if(state is BranchLoading){
                            return const Center(child: CircularProgressIndicator(color: ColorsManager.primaryColor,),);
                          }
                          return CustomMainButton(
                            label: screenTitle,
                            width: 220,
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                if (widget.branch == null) {
                                  context.read<BranchBloc>().add(
                                    AddBranch(
                                      BranchModel(
                                        name: _nameController.text,
                                        location: _locationController.text,
                                        managerName: _managerController.text,
                                        phone: _phoneController.text,
                                      ),
                                    ),
                                  );
                                } else {
                                  context.read<BranchBloc>().add(
                                    UpdateBranch(
                                      id: widget.branch!.id!,
                                      updatedBranch: BranchModel(
                                        name: _nameController.text,
                                        location: _locationController.text,
                                        managerName: _managerController.text,
                                        phone: _phoneController.text,
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}