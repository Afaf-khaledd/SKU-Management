import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sku/features/SKUs/presentation/logic/items_bloc.dart';
import 'package:sku/features/SKUs/presentation/logic/items_state.dart';

class CategoryPieChart extends StatelessWidget {
  const CategoryPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color.fromRGBO(37, 150, 190, 0.8),
      const Color.fromRGBO(161, 216, 236, 1),
      const Color.fromRGBO(131, 204, 231, 1),
      const Color.fromRGBO(76, 181, 220, 1),
      const Color.fromRGBO(30, 120, 153, 0.8),
      const Color.fromRGBO(22, 89, 114, 1),
    ];

    return BlocBuilder<ItemsBloc, ItemsState>(
      builder: (context, state) {
        if (state is SKULoaded) {
          final Map<String, int> categoryCounts = {};

          for (var sku in state.items) {
            final categoryName = sku.category.name;
            categoryCounts[categoryName] = (categoryCounts[categoryName] ?? 0) + 1;
          }

          final sorted = categoryCounts.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));
          final top6 = sorted.take(6).toList();

          final total = top6.fold<int>(0, (sum, e) => sum + e.value);
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      sections: List.generate(top6.length, (index) {
                        final entry = top6[index];
                        final percentage = (entry.value / total * 100).toStringAsFixed(1);
                        return PieChartSectionData(
                          color: colors[index % colors.length],
                          value: entry.value.toDouble(),
                          title: '${entry.value} ${entry.value == 1 ? 'Item' : 'Items'}',
                          radius: 60,
                          titleStyle: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width*0.03,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }),
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                    ),
                  ),
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width*.015),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(top6.length, (index) {
                    final entry = top6[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.008),
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width*0.022,
                            height: MediaQuery.of(context).size.height*0.022,
                            decoration: BoxDecoration(
                              color: colors[index],
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width*0.02),
                          Text(entry.key,style: GoogleFonts.poppins(fontWeight: FontWeight.w500),),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          );
        } else {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: MediaQuery.of(context).size.height*0.32,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
    );
  }
}