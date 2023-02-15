import 'package:flutter/material.dart';
import 'package:kartoraeat/dialogs/generic_dialog.dart';

import '../auth/auth_error.dart';

Future<void> showAuthError({
    required AuthError authError,
    required BuildContext context
})
{
  return showGenericDialog<void>(
    context: context,
    title: authError.dialogTitle,
    content: authError.dialogText,
    optionsBuilder: () => {
      'Ok': true,
    },
  );
}