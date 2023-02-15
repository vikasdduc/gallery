import 'package:flutter/material.dart' show BuildContext;
import 'package:kartoraeat/dialogs/generic_dialog.dart';

Future<bool> showDeleteAccountDialog(
BuildContext context
    )
{
  return showGenericDialog(
      context: context,
      title: 'Delete Account',
      content: 'Are you sure you want to delete your account? You can not undo this operation',
      optionsBuilder: () => {
        'Cancel': false,
        'Delete account' :true
      },
    ).then(
          (value) => value ?? false
  );
}