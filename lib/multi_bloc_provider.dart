import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:DigiRestro/service_locator.dart';
import 'package:DigiRestro/src/repository/cart/cart_cubit.dart';
import 'package:DigiRestro/src/repository/image_pick/cubit/image_picker_cubit.dart';
import 'package:DigiRestro/src/repository/items/items_cubit.dart';
import 'src/repository/login/login_bloc.dart';

class MultiBlocProviderClass extends StatelessWidget {
  final Widget child;
  const MultiBlocProviderClass(this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<LoginBloc>(
        create: (_) => LoginBloc(sl(), sl(), sl()),
      ),

      //-------Cubits
      BlocProvider<ItemsCubit>(
        create: (_) => ItemsCubit(sl()),
      ),
      BlocProvider<CartCubit>(
        create: (_) => CartCubit(sl()),
      ),
      BlocProvider(create: (_) => ImagePickerCubit())
    ], child: child);
  }
}
