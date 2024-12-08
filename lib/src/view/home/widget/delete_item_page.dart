import 'package:DigiRestro/utils/string_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:DigiRestro/commons/controls/custom_text.dart';
import 'package:DigiRestro/src/repository/items/items_cubit.dart';

import 'package:DigiRestro/utils/extension.dart';
import '../../../model/item_model.dart';

class DeleteItemPage extends StatefulWidget {
  DeleteItemPage({
    super.key,
  });

  @override
  State<DeleteItemPage> createState() => _DeleteItemPageState();
}

class _DeleteItemPageState extends State<DeleteItemPage> {
  @override
  void initState() {
    context.read<ItemsCubit>().getItems();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return context.read<ItemsCubit>().getItems();
      },
      child: Scaffold(
          appBar: AppBar(
            title: CustomText(size: 14.h, text: "Delete Item Form Menu"),
          ),
          body: SafeArea(
            child: CustomScrollView(slivers: [
              BlocBuilder<ItemsCubit, ItemsState>(
                builder: (context, state) {
                  if (state is ItemsLoaded) {
                    if (state.modelList.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: CustomText(text: 'No menu to show'),
                        ),
                      );
                    } else {
                      return DeleteTableCards(
                        itemIdList: state.listOfItemIds,
                        listOfTables: state.modelList,
                      );
                    }
                  } else {
                    return const SliverToBoxAdapter(
                      child: SizedBox.shrink(),
                    );
                  }
                },
              ),
              SliverToBoxAdapter(child: Gap(20.h)),
            ]).addMargin(EdgeInsets.symmetric(horizontal: 16)),
          )),
    );
  }
}

class DeleteTableCards extends StatefulWidget {
  const DeleteTableCards({Key? key, this.listOfTables, this.itemIdList})
      : super(key: key);
  final List<ItemModel>? listOfTables;
  final List<String>? itemIdList;

  @override
  State<DeleteTableCards> createState() => _DeleteTableCardsState();
}

class _DeleteTableCardsState extends State<DeleteTableCards> {
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
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap(4.h),
                            CustomText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                fontName: AppFonts.poppins,
                                fontWeight: FontWeight.w500,
                                size: 14.h,
                                text: widget.listOfTables?[index].name
                                        .toString() ??
                                    ''),
                            CustomText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                size: 12.h,
                                text: widget.listOfTables?[index].price
                                        .toString() ??
                                    ''),
                            CustomText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                size: 12.h,
                                text: widget.listOfTables?[index].category
                                        .toString() ??
                                    ''),
                          ],
                        ),
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
                onPressed: () async {
                  EasyLoading.show(
                      indicator: CircularProgressIndicator(),
                      maskType: EasyLoadingMaskType.clear,
                      dismissOnTap: false);
                  await context
                      .read<ItemsCubit>()
                      .deleteItem(documentId: widget.itemIdList?[index] ?? '');
                  await context.read<ItemsCubit>().getItems();
                  EasyLoading.dismiss();
                },
                icon: Icon(
                  Icons.remove_circle,
                  color: Colors.redAccent,
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
