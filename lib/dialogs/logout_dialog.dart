
import 'package:flutter/material.dart' show BuildContext;
import 'package:kartoraeat/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(
    BuildContext context
    )
{
  return showGenericDialog(
    context: context,
    title: 'Log Out',
    content: 'Are you sure you want to log out your account!',
    optionsBuilder: () => {
      'Cancel': false,
      'Log Out' :true
    },
  ).then(
          (value) => value ?? false
  );
}