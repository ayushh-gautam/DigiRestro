import 'package:DigiRestro/commons/controls/custom_button.dart';
import 'package:DigiRestro/commons/controls/custom_text.dart';
import 'package:DigiRestro/multi_bloc_provider.dart';
import 'package:DigiRestro/src/repository/cart/cart_cubit.dart';
import 'package:DigiRestro/src/repository/table/cubit/table_cubit.dart';
import 'package:DigiRestro/src/view/home/page/home_page.dart';
import 'package:DigiRestro/utils/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TablePage extends StatefulWidget {
  const TablePage({super.key, required this.userCredential});
  final UserCredential userCredential;

  @override
  State<TablePage> createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  @override
  void initState() {
    super.initState();
    context.read<TableCubit>().getTables();
    context.read<TableCubit>().getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TableCubit, TableState>(
        builder: (context, state) {
          // var bookedTable = state.orderHistoryModel?.contains(element);
          return RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            onRefresh: () async {
              context.read<TableCubit>().getTables();
              context.read<TableCubit>().getOrders();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.tableData?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        (state.bookedIds?.contains(state
                                    .tableData?[index].tableNumber
                                    .toString()) ??
                                false)
                            ? null
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(
                                    userCredential: widget.userCredential,
                                    currentTableNumber:
                                        state.tableData?[index].tableNumber ??
                                            0,
                                  ),
                                ));
                      },
                      child: ListTile(
                        tileColor: (state.bookedIds?.contains(state
                                    .tableData?[index].tableNumber
                                    .toString()) ??
                                false)
                            ? Colors.red
                            : Colors.green,
                        title: CustomText(
                            color: AppColor.black,
                            text: state.tableData?[index].tableNumber
                                    .toString() ??
                                ''),
                      ),
                    );
                  },
                ),
                CustomButton(
                  onTap: () {
                    context.read<TableCubit>().setTableInfo().then(
                      (value) {
                        context.read<TableCubit>().getTables();
                        context.read<TableCubit>().getOrders();
                      },
                    );
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
// HomePage(userCredential: userCredential)