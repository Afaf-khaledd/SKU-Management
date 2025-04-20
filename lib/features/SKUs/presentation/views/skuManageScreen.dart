import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sku/features/SKUs/presentation/logic/items_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/components/customMainButton.dart';
import '../../../../core/components/customWhiteTextField.dart';
import '../../../../core/helper/input_validators.dart';
import '../../../../core/utils/colors.dart';
import '../../data/model/skuModel.dart';
import '../logic/items_event.dart';
import '../logic/items_state.dart';

class SKUManageScreen extends StatefulWidget {
  final SKUModel? item;

  const SKUManageScreen({super.key, required this.item});

  @override
  State<SKUManageScreen> createState() => _SKUManageScreenState();
}

class _SKUManageScreenState extends State<SKUManageScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  Category? selectedCategory;
  SubCategory? selectedSubCategory;
  File? _imageFile;
  String? _uploadedImageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _nameController.text = widget.item!.name;
      _brandController.text = widget.item!.brand;
      _codeController.text = widget.item!.skuCode;
      selectedCategory = widget.item!.category;
      selectedSubCategory = widget.item!.subCategory;
      _uploadedImageUrl = widget.item!.image;
    }
    _codeController.addListener(() {
      setState(() {});
    });
  }

  String generateRandomSKU() {
    final random = Random();
    return 'SKU${random.nextInt(999999)}';
  }

  Future<void> pickImageAndUpload() async {
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (picked != null) {
        setState(() => _imageFile = File(picked.path));

        final url = await uploadImageToSupabase(_imageFile!);
        if (url != null) {
          setState(() => _uploadedImageUrl = url);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Image upload failed")),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Exception in pickImageAndUpload: $e")),
      );
    }
  }

  Future<String?> uploadImageToSupabase(File imageFile) async {
    final supabase = Supabase.instance.client;

    if (supabase.auth.currentUser == null) {
      await supabase.auth.signInAnonymously();
    }

    final fileName = 'item_${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';
    final storage = supabase.storage.from('sku-images');

    try {
      final response = await storage.upload('items/$fileName', imageFile);
      if (response.isNotEmpty) {
        final url = storage.getPublicUrl('items/$fileName');
        return url;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _brandController.dispose();
    _codeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String screenTitle = widget.item == null ? "Add Item" : "Update Item";
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('SKU Management',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: screenWidth*0.06),
        ),
        leading: IconButton(
            onPressed: (){
              context.pop();
            }
            , icon: Icon(Icons.arrow_back_ios_rounded)),
        toolbarHeight: screenHeight*0.12,
        centerTitle: true,
        backgroundColor: Color.fromRGBO(255, 255, 255, 1000),
      ),
      body: BlocListener<ItemsBloc, ItemsState>(
        listener: (context, state) {
          if (state is SKUFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          } else if (state is SKUOperationSuccess) {
            context.read<ItemsBloc>().add(LoadSKUs());
            if (widget.item != null && widget.item!.id != null) {
              context.read<ItemsBloc>().add(GetItemById(widget.item!.id!));
            }
            context.pop();
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.025),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: pickImageAndUpload,
                      child: _uploadedImageUrl != null
                          ? Image.network(_uploadedImageUrl!, height: screenHeight*0.14,errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),)
                          : Container(
                        height: screenWidth*0.4,
                        width: screenWidth*0.4,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.add_photo_alternate_outlined, size: screenWidth*0.15),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight*0.025),
                  Text('  SKU Name',style: GoogleFonts.poppins(fontWeight: FontWeight.w500),),
                  CustomWhiteTextField(
                    controller: _nameController,
                    hintText: 'SKU name',
                    validator: InputValidators.validateItemName,
                  ),
                  SizedBox(height: screenHeight*0.02),
                  Text('  SKU Brand',style: GoogleFonts.poppins(fontWeight: FontWeight.w500),),
                  CustomWhiteTextField(
                    controller: _brandController,
                    hintText: 'Brand',
                    validator: InputValidators.validateItemBrand,
                  ),
                  SizedBox(height: screenHeight*0.02),
                  Text('  SKU Category',style: GoogleFonts.poppins(fontWeight: FontWeight.w500),),
                  DropdownButtonFormField<Category>(
                    value: selectedCategory,
                    hint: const Text('Categories'),
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorsManager.primaryColor, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                    items: Category.values.map((cat) {
                      return DropdownMenuItem(value: cat, child: Text(cat.name));
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedCategory = val;
                        selectedSubCategory = null;
                      });
                    },
                  ),
                  SizedBox(height: screenHeight*0.02),
                  Text('  SKU Subcategory',style: GoogleFonts.poppins(fontWeight: FontWeight.w500),),
                  DropdownButtonFormField<SubCategory>(
                    value: selectedSubCategory,
                    hint: const Text('Subcategories'),
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorsManager.primaryColor, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                    items: selectedCategory == null
                        ? []
                        : SKUModel.getSubCategories(selectedCategory!).map((sub) {
                      return DropdownMenuItem(value: sub, child: Text(sub.name));
                    }).toList(),
                    onChanged: (val) => setState(() => selectedSubCategory = val),
                  ),
                  SizedBox(height: screenHeight*0.02),

                  Text('  SKU Code',style: GoogleFonts.poppins(fontWeight: FontWeight.w500),),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: CustomWhiteTextField(
                          controller: _codeController,
                          hintText: 'e.g. SKU123',
                          validator: InputValidators.validateItemCode,
                          suffixIcon: IconButton(
                            tooltip: 'Auto-generating?',
                            icon: const Icon(Icons.flash_auto_outlined, color: ColorsManager.subTextBlackColor),
                            onPressed: () {
                              final code = generateRandomSKU();
                              setState(() => _codeController.text = code);
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight*0.02),
                      if (_codeController.text.isNotEmpty)
                        QrImageView(data: _codeController.text, size: screenWidth*0.23),
                    ],
                  ),
                  SizedBox(height: screenHeight*0.015),
                  BlocBuilder<ItemsBloc, ItemsState>(
                    builder: (context, state) {
                      if (state is SKULoading) {
                        return const CircularProgressIndicator(color: ColorsManager.primaryColor);
                      }
                      return CustomMainButton(
                        label: screenTitle,
                        width: screenWidth*0.55,
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            final newItem = SKUModel(
                              name: _nameController.text,
                              skuCode: _codeController.text,
                              category: selectedCategory!,
                              subCategory: selectedSubCategory!,
                              brand: _brandController.text,
                              image: _uploadedImageUrl,
                            );
                            if (widget.item == null) {
                              context.read<ItemsBloc>().add(AddSKU(newItem));
                            } else {
                              context.read<ItemsBloc>().add(UpdateSKU(widget.item!.id!, newItem));
                            }
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}