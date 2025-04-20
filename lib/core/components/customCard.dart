import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:sku/core/utils/colors.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final List<String> subtitles;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final Widget trailing;
  final Widget? deactivate;
  final bool isDismissible;

  const CustomCard({
    super.key,
    required this.title,
    required this.subtitles,
    this.onTap,
    this.onDelete,
    required this.trailing,
    this.deactivate,
    this.isDismissible = true,
  });

  @override
  Widget build(BuildContext context) {
    return isDismissible
        ? Dismissible(
      key: ValueKey(title),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        bool? shouldDelete = false;

        await QuickAlert.show(
          context: context,
          type: QuickAlertType.confirm,
          title: 'Confirm Deletion',
          text: 'Are you sure you want to delete this branch?',
          confirmBtnText: 'Delete',
          cancelBtnText: 'Cancel',
          confirmBtnColor: ColorsManager.primaryColor,
          onConfirmBtnTap: () {
            shouldDelete = true;
            Navigator.of(context).pop();
          },
          onCancelBtnTap: () {
            shouldDelete = false;
            Navigator.of(context).pop();
          },
        );

        return shouldDelete;
      },
      onDismissed: (_) => onDelete?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 15),
        color: Colors.redAccent,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: _buildCard(context),
    )
        : _buildCard(context);
  }

  Widget _buildCard(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  ...subtitles.map((sub) => Text(
                    sub,
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                  )),
                  SizedBox(height: 5),
                  if (deactivate != null) deactivate!
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width*0.35,
              height: MediaQuery.of(context).size.width*0.35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: trailing,
              ),
            ),
          ],
        ),
      ),
    );
  }
}