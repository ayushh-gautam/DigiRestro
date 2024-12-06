// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:DigiRestro/commons/controls/custom_text.dart';
import 'package:DigiRestro/src/model/item_model.dart';
import 'package:DigiRestro/src/repository/cart/cart_cubit.dart';
import 'package:DigiRestro/utils/app_color.dart';
import 'package:DigiRestro/utils/string_constant.dart';
import 'package:gap/gap.dart';

class TableCardGrid extends StatefulWidget {
  const TableCardGrid({
    Key? key,
    this.listOfTables,
  }) : super(key: key);
  final List<ItemModel>? listOfTables;

  @override
  State<TableCardGrid> createState() => _TableCardGridState();
}

class _TableCardGridState extends State<TableCardGrid> {
  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.9,
          crossAxisCount: 2,
          crossAxisSpacing: 6.0,
          mainAxisSpacing: 14.0),
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 7.h, right: 2.h, top: 4.h),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8.h)),
                    child: Image.network(
                      widget.listOfTables?[index].image == ''
                          ? 'https://www.tasteofhome.com/wp-content/uploads/2018/01/Crispy-Fried-Chicken_EXPS_TOHJJ22_6445_DR-_02_03_11b.jpg?fit=700,700'
                          : widget.listOfTables?[index].image ?? '',
                      height: 100.h,
                      width: 200.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(4.h),
                          CustomText(
                              fontName: AppFonts.poppins,
                              fontWeight: FontWeight.w500,
                              size: 14.h,
                              text:
                                  widget.listOfTables?[index].name.toString() ??
                                      ''),
                          CustomText(
                              size: 12.h,
                              text: widget.listOfTables?[index].price
                                      .toString() ??
                                  ''),
                          CustomText(
                              size: 12.h,
                              text: widget.listOfTables?[index].category
                                      .toString() ??
                                  ''),
                        ],
                      ),
                      //add button here
                    ],
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                onPressed: () {
                  context
                      .read<CartCubit>()
                      .addToCart(widget.listOfTables?[index]);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(milliseconds: 400),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      margin: const EdgeInsets.only(
                          bottom: 20, left: 10, right: 10),
                      content: const Text('Item added to cart')));
                },
                icon: Icon(
                  Icons.add_circle,
                  color: AppColor.subBlue,
                ),
                iconSize: 30.h,
              ),
            )
          ],
        );
      }, childCount: widget.listOfTables?.length),
    );
  }
}
