import 'package:DigiRestro/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:DigiRestro/commons/controls/custom_button.dart';
import 'package:DigiRestro/commons/controls/custom_text.dart';
import 'package:DigiRestro/src/repository/table/cubit/table_cubit.dart';
import 'package:DigiRestro/src/view/home/page/home_page.dart';
import 'package:DigiRestro/utils/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TablePage extends StatefulWidget {
  const TablePage({super.key, this.userCredential});
  final UserCredential? userCredential;

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

  _addTable(int tableNumber) {
    context.read<TableCubit>().setTableInfo(tableNumber).then(
      (value) {
        context.read<TableCubit>().getTables();
        context.read<TableCubit>().getOrders();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Table $tableNumber has been added successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      },
    );
  }

  Future<void> _confirmAndDeleteTable(String tableId) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Table"),
          content: const Text(
              "Are you sure you want to delete this table? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel the deletion
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm the deletion
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (result == true) {
      // User confirmed deletion
      context.read<TableCubit>().deleteTable(tableId).then(
        (value) {
          context.read<TableCubit>().getTables();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Table has been deleted successfully!"),
              backgroundColor: Colors.red,
            ),
          );
        },
      ).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Failed to delete table."),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomText(
          text: 'Select a Table',
          fontWeight: FontWeight.w600,
          size: 20.h,
        ),
      ),
      bottomNavigationBar: CustomButton(
        padding: EdgeInsets.zero,
        onTap: () async {
          final TextEditingController tableNumberController =
              TextEditingController();
          bool isValid = false;
          await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Add New Table"),
                content: TextField(
                  controller: tableNumberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Table Number",
                    hintText: "Enter a table number",
                    errorText:
                        isValid ? null : "Please enter a valid table number",
                  ),
                  onChanged: (value) {
                    setState(() {
                      isValid = int.tryParse(value) != null;
                    });
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (int.tryParse(tableNumberController.text) != null) {
                        Navigator.of(context).pop(tableNumberController.text);
                      } else {
                        setState(() {
                          isValid = false;
                        });
                      }
                    },
                    child: const Text("Confirm"),
                  ),
                ],
              );
            },
          ).then((result) {
            if (result != null) {
              // Use the entered table number
              _addTable(int.parse(result));
            }
          });
        },
        text: "Add New Table",
        color: AppColor.playButtonBg,
        textColor: Colors.black,
      ).addMargin(EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.h)),
      body: BlocBuilder<TableCubit, TableState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<TableCubit>().getTables();
              context.read<TableCubit>().getOrders();
            },
            child: state.tableData == null
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColor.primaryBlue,
                    ),
                  )
                : (state.tableData?.isEmpty ?? true)
                    ? Center(child: CustomText(text: 'No tables. Add one!'))
                    : Column(
                        children: [
                          Expanded(
                            child: Padding(
                                padding: EdgeInsets.all(16.0.h),
                                child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                  ),
                                  itemCount: state.tableData?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    // this is for sorting table number in ascending order
                                    final sortedTableData = state.tableData!
                                      ..sort((a, b) =>
                                          a.tableNumber
                                              ?.compareTo(b.tableNumber ?? 0) ??
                                          0);
                                    final table = sortedTableData[index];
                                    final isBooked = state.bookedIds?.contains(
                                            table.tableNumber.toString()) ??
                                        false;

                                    return Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: isBooked
                                              ? null
                                              : () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomePage(
                                                        userCredential: widget
                                                            .userCredential!,
                                                        currentTableNumber:
                                                            table.tableNumber ??
                                                                0,
                                                      ),
                                                    ),
                                                  );
                                                },
                                          child: Card(
                                            elevation: 4,
                                            color: isBooked
                                                ? Colors.red.shade300
                                                : Colors.green.shade300,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CustomText(
                                                    text:
                                                        "Table ${table.tableNumber}",
                                                    color: Colors.white,
                                                    size: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  CustomText(
                                                    text: isBooked
                                                        ? "Booked"
                                                        : 'Free',
                                                    color: Colors.white,
                                                    size: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              _confirmAndDeleteTable(
                                                  table.tableId ?? "");
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                )),
                          ),
                        ],
                      ),
          );
        },
      ),
    );
  }
}
