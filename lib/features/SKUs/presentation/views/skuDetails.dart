import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sku/core/utils/colors.dart';
import 'package:sku/features/SKUs/presentation/logic/items_bloc.dart';
import 'package:sku/features/SKUs/presentation/logic/items_event.dart';
import 'package:sku/features/SKUs/presentation/logic/items_state.dart';

class SKUDetails extends StatefulWidget {
  final String itemId;


  const SKUDetails({super.key, required this.itemId});

  @override
  State<SKUDetails> createState() => _SKUDetailsState();
}

class _SKUDetailsState extends State<SKUDetails> {

  @override
  void initState() {
    super.initState();
    context.read<ItemsBloc>().add(GetItemById(widget.itemId));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('SKU Details',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: screenWidth*0.06),
        ),
        centerTitle: true,
        leading: IconButton(
        onPressed: (){
          context.pop();
          context.read<ItemsBloc>().add(LoadSKUs());
        }
        , icon: Icon(Icons.arrow_back_ios_rounded)),
        toolbarHeight: screenHeight*0.12,
        backgroundColor: Colors.transparent,
        actions: [
          BlocBuilder<ItemsBloc, ItemsState>(
            builder: (context, state) {
              if (state is SKUItemLoaded) {
                return IconButton(
                  onPressed: () => context.push('/manage-item', extra: state.item),
                  icon: const Icon(Icons.edit_note_outlined),
                );
              }
              return const SizedBox();
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<ItemsBloc, ItemsState>(
          builder: (context, state) {
            if (state is SKUItemLoaded) {
              final item = state.item;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth*0.06),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${item.name[0].toUpperCase()}${item.name.substring(1)}",
                            style: GoogleFonts.poppins(fontSize: screenWidth*0.055, fontWeight: FontWeight.bold)),
                        Text(item.skuCode,
                            style: GoogleFonts.poppins(
                                fontSize: screenWidth*0.045,
                                fontWeight: FontWeight.w500,
                                color: ColorsManager.subTextBlackColor)),
                      ],
                    ),
                    SizedBox(height: screenHeight*0.03),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Category: ${item.category.name[0].toUpperCase()}${item.category.name.substring(1)}',
                                style: GoogleFonts.poppins(
                                    fontSize: screenWidth*0.045,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800]),
                              ),
                              SizedBox(height: screenHeight*0.02),
                              Text(
                                'SubCategory:\n${item.subCategory.name[0].toUpperCase()}${item.subCategory.name.substring(1)}',
                                style: GoogleFonts.poppins(
                                    fontSize: screenWidth*0.045,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800]),
                              ),
                              SizedBox(height: screenHeight*0.02),
                              Text('Brand: ${item.brand[0].toUpperCase()}${item.brand.substring(1)}',
                                  style: GoogleFonts.poppins(
                                      fontSize: screenWidth*0.045,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[800])),
                            ],
                          ),
                        ),
                        SizedBox(width: screenWidth*0.015),
                        Container(
                          width: screenWidth*0.4,
                          height: screenWidth*0.4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[200],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.image ?? '',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight*0.05),
                    Text('Item QR Code:',
                        style: GoogleFonts.poppins(
                            fontSize: screenWidth*0.045, fontWeight: FontWeight.w600, color: Colors.grey[800])),
                    QrImageView(data: item.skuCode, size: screenWidth*0.5),
                  ],
                ),
              );
            } else if (state is SKUFailure) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: SizedBox());
            }
          },
        ),
      ),
    );
  }
}