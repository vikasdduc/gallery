
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartoraeat/bloc/app_bloc.dart';
import 'package:kartoraeat/bloc/app_event.dart';
import 'package:kartoraeat/dialogs/delete_account_dialog.dart';
import 'package:kartoraeat/dialogs/logout_dialog.dart';

enum MenuAction {
  logout ,deleteAccount
}

class MainPopupMenuButton extends StatelessWidget {
  const MainPopupMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
      onSelected: (value) async {
        switch (value){

          case MenuAction.logout:
            final shouldLogOut = await showLogOutDialog(context);
            if(shouldLogOut){
              context.read<AppBloc>().add(
                const AppEventLogOut()
              );
            }
            break;
          case MenuAction.deleteAccount:
            final shouldDeleteAccount = await showDeleteAccountDialog(context);
            if(shouldDeleteAccount){
              context.read<AppBloc>().add(
                  const AppEventDeleteAccount()
              );
            }
            break;
        }
      },
      itemBuilder: (context){
          return[
            const PopupMenuItem(
              value: MenuAction.logout,
              child: Text('Log Out'),
            ),
            const PopupMenuItem(
              value: MenuAction.deleteAccount,
              child: Text('Delete account'),
            ),

          ];

        },
    );
  }
}
