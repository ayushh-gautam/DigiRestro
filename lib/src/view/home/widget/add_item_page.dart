import 'package:DigiRestro/commons/controls/custom_text.dart';
import 'package:DigiRestro/commons/controls/custom_textfield.dart';
import 'package:DigiRestro/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../commons/controls/custom_button.dart';
import '../../../../utils/app_color.dart';
import '../../../repository/image_pick/cubit/image_picker_cubit.dart';
import '../../../repository/items/items_cubit.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController categoriesController;

  @override
  void initState() {
    nameController = TextEditingController();
    priceController = TextEditingController();
    categoriesController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: 'Add Item To Menu'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomTextField(
              controller: nameController,
              hintText: 'Item Name',
              borderSide: const BorderSide(),
            ),
            Gap(10.h),
            CustomTextField(
              hintText: 'Item Price',
              controller: priceController,
              borderSide: const BorderSide(),
            ),
            Gap(10.h),
            CustomTextField(
              hintText: 'Item Category',
              controller: categoriesController,
              borderSide: const BorderSide(),
            ),
            Gap(18.h),
            CustomButton(
              onTap: () {
                context.read<ImagePickerCubit>().pickImage();
              },
              color: AppColor.lightBlue,
              widget: CustomText(text: 'Choose Image for Item'),
            ),
            Gap(12.h),
            Row(
              children: [
                BlocBuilder<ImagePickerCubit, ImagePickerState>(
                  builder: (context, state) {
                    if (state is ImagePickerPicked) {
                      return Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.h)),
                        child: Image.file(
                          state.myFile,
                          height: 150.h,
                          width: 150.h,
                          fit: BoxFit.cover,
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ],
            ),
            Gap(10.h),
            BlocBuilder<ImagePickerCubit, ImagePickerState>(
              builder: (context, state) {
                return CustomButton(
                  onTap: () async {
                    if (state is ImagePickerPicked) {
                      //
                      EasyLoading.show(
                          indicator: CircularProgressIndicator(),
                          maskType: EasyLoadingMaskType.clear,
                          dismissOnTap: false);
                      await context
                          .read<ImagePickerCubit>()
                          .uploadImage(state.myFile)
                          .then((value) => context
                              .read<ItemsCubit>()
                              .createItems(
                                  nameController.text.trim(),
                                  categoriesController.text.trim(),
                                  priceController.text.trim().toString(),
                                  value))
                          .then(
                        (value) {
                          EasyLoading.dismiss();
                        
                        },
                      );
                    }
                    Navigator.pop(context);
                  },
                  text: 'Save',
                  height: 50,
                  // width: 150,
                  textColor: AppColor.white,
                );
              },
            )
          ],
        ).addMargin(EdgeInsets.all(16.h)),
      ),
    );
  }
}
