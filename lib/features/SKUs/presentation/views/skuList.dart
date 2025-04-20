import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sku/core/utils/colors.dart';
import 'package:sku/features/SKUs/presentation/logic/items_bloc.dart';
import 'package:sku/features/SKUs/presentation/logic/items_event.dart';
import 'package:sku/features/SKUs/presentation/logic/items_state.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../../../../core/components/customCard.dart';
import '../../../../core/components/emptyListView.dart';
import '../../../../core/components/shimmerCards.dart';
import '../../../../core/helper/BottomNavHandler.dart';

class SKUsListScreen extends StatefulWidget {
  const SKUsListScreen({super.key});

  @override
  State<SKUsListScreen> createState() => _SKUsListScreenState();
}

class _SKUsListScreenState extends State<SKUsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  String? filterStatus;
  String? filterCategory;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<ItemsBloc>().add(LoadSKUs());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: screenHeight*0.12,
        backgroundColor: Color.fromRGBO(255, 255, 255, 1000),
        elevation: 0,
        title: Text("SKU List",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: screenWidth*0.065),),
        centerTitle: true,
        actions: [
          IconButton(onPressed: ()=> context.push('/manage-item',extra: null), icon: Icon(Icons.add_box_outlined),tooltip: 'Add new Item',),
          SizedBox(width: 11,),
        ],
      ),
      bottomNavigationBar: BottomNavHandler(
        currentIndex: 2,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03,
              vertical: screenHeight * 0.01,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => searchQuery = value),
                    decoration: InputDecoration(
                      hintText: "Search by name or code.",
                      hintStyle: GoogleFonts.poppins(color: ColorsManager.subTextBlackColor),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.qr_code_scanner_rounded),
                        onPressed: _scanQrcode,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(17),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(17),
                        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.7),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(17),
                        borderSide: BorderSide(color: ColorsManager.primaryColor, width: 1.5),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: screenWidth*0.015),
                IconButton(
                  icon: const Icon(Icons.filter_alt_outlined),
                  tooltip: 'Filter by status or category',
                  onPressed: () => _showFilterDialog(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<ItemsBloc, ItemsState>(
              builder: (context, state) {
                if (state is SKULoading) {
                  return const ShimmerCards();
                } else if (state is SKUFailure) {
                  return Center(child: Text('Error: ${state.message}'));
                } else if (state is SKULoaded) {
                  var items = state.items;

                  if (filterStatus != null && filterStatus != 'All') {
                    items = items.where((e) =>
                    (filterStatus == "Active" && e.isActive) ||
                        (filterStatus == "Inactive" && !e.isActive)).toList();
                  }

                  if (filterCategory != null && filterCategory != 'All') {
                    items = items
                        .where((e) => e.category.name == filterCategory)
                        .toList();
                  }

                  items = items
                      .where((item) =>
                  item.name
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()) ||
                      item.skuCode
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()))
                      .toList();

                  if (items.isEmpty) {
                    return const EmptyListView(
                      title: 'No Items found.',
                      icon: Icons.not_interested_outlined,
                      desc: "There's no items yet,\nYou can add new items easily!",
                    );
                  }

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return CustomCard(
                        title: item.name,
                        subtitles: [
                          'Category: ${item.category.name[0].toUpperCase()}${item.category.name.substring(1)}',
                          'Brand: ${item.brand}',
                          'State: ${item.isActive ? "Active" : "Inactive"}',
                        ],
                        trailing: Image.network(
                          item.image ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported),
                        ),
                        isDismissible: false,
                        onTap: () => context.push('/item-details', extra: item),
                        deactivate: OutlinedButton(
                          onPressed: () {
                            context
                                .read<ItemsBloc>()
                                .add(DeactivateSKU(item.id!, !item.isActive));
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: ColorsManager.primaryColor),
                          ),
                          child: Text(
                            item.isActive ? "Deactivate" : "Activate",
                            style: GoogleFonts.poppins(
                              color: ColorsManager.primaryColor,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox(); // fallback
              },
            ),
          ),
        ],
      ),
    );
  }
  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        String? tempStatus = filterStatus ?? 'All';
        String? tempCategory = filterCategory ?? 'All';

        return AlertDialog(
          title: Text('Filter Items',style: GoogleFonts.poppins(fontWeight: FontWeight.w500),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: tempStatus,
                decoration: InputDecoration(
                  label: Text("Status",style: GoogleFonts.poppins(color: ColorsManager.primaryColor,fontWeight: FontWeight.w500),),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorsManager.primaryColor, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                onChanged: (value) => tempStatus = value,
                items: ['All', 'Active', 'Inactive']
                    .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status,style: GoogleFonts.poppins(fontWeight: FontWeight.w400),),
                ))
                    .toList(),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.013),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  label: Text("Category",style: GoogleFonts.poppins(color: ColorsManager.primaryColor,fontWeight: FontWeight.w500),),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorsManager.primaryColor, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                value: tempCategory,
                onChanged: (value) => tempCategory = value,
                items: ['All', 'electronics', 'fashion', 'food', 'books', 'personal', 'furniture']
                    .map((cat) => DropdownMenuItem(
                  value: cat,
                  child: Text(cat,style: GoogleFonts.poppins(fontWeight: FontWeight.w400)),
                ))
                    .toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',style: GoogleFonts.poppins(color: ColorsManager.primaryColor,fontWeight: FontWeight.w400),),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.primaryColor
              ),
              onPressed: () {
                setState(() {
                  filterStatus = tempStatus == 'All' ? null : tempStatus;
                  filterCategory = tempCategory == 'All' ? null : tempCategory;
                });
                Navigator.pop(context);
              },
              child: Text('Apply',style: GoogleFonts.poppins(fontWeight: FontWeight.w500,color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
  Future<void> _scanQrcode() async {
    try {
      String qrResult = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666",
        "Cancel",
        true,
        ScanMode.QR,
      );

      if (qrResult != "-1") {
        setState(() {
          _searchController.text = qrResult;
          searchQuery = qrResult;
        });
      }
    } catch (e) {
      print("QR scanning failed: $e");
    }
  }
}