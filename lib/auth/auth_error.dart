//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/foundation.dart' show immutable;

const  Map<String, AuthError> authErrorMapping = {
  'user-not-fount': AuthErrorUserNotFound(),
  'weak-password' : AuthErrorWeakPassword(),
  'invalid-email': AuthErrorInvalidEmail(),
  'operation-not-allowed':AuthErrorOperationNotAllowed(),
  'email-already-in-use':AuthErrorEmailAlreadyInUse(),
  'requires-recent-login': AuthErrorRequiresRecentLogin(),
  'no-current-user' : AuthErrorNoCurrentUser(),
};

@immutable
abstract class AuthError{
  final String dialogTitle;
  final String dialogText;

  const AuthError({
    required this.dialogTitle,
    required this.dialogText});

  factory AuthError.from(FirebaseAuthException exception)=>
      authErrorMapping[exception.code.toLowerCase().trim()]
      ??  const AuthErrorUnKnown();

}

@immutable
class AuthErrorUnKnown extends AuthError{

  const AuthErrorUnKnown() :super(
      dialogText: 'Authentication error',
      dialogTitle: 'Unknown authentication error',
  );
}

@immutable
class AuthErrorNoCurrentUser extends AuthError{
  const AuthErrorNoCurrentUser() :super(
    dialogText: 'No current User',
    dialogTitle: 'No current user with this information was found',
  );
}

@immutable
class AuthErrorRequiresRecentLogin extends AuthError{

  const AuthErrorRequiresRecentLogin() :super(
    dialogText: 'Requires Recent Login',
    dialogTitle: 'You need to log out log back in at this moment',
  );
}

@immutable
class AuthErrorOperationNotAllowed extends AuthError{

  const AuthErrorOperationNotAllowed() :super(
    dialogText: 'Operation not allowed',
    dialogTitle: 'You cannot register using this method at this moment',
  );
}

@immutable
class AuthErrorUserNotFound extends AuthError{

  const AuthErrorUserNotFound() :super(
    dialogText: 'User not found',
    dialogTitle: 'The given user was not found on the server!',
  );
}

@immutable
class AuthErrorWeakPassword extends AuthError{

  const AuthErrorWeakPassword() :super(
    dialogText: 'Weak password',
    dialogTitle: 'Please choose a stronger password consisting of more character!',
  );
}

@immutable
class AuthErrorInvalidEmail extends AuthError{

  const AuthErrorInvalidEmail() :super(
    dialogText: 'Invalid Email',
    dialogTitle: 'Please double check your email and try again!',
  );
}

@immutable
class AuthErrorEmailAlreadyInUse extends AuthError{

  const AuthErrorEmailAlreadyInUse() :super(
    dialogText: 'Email already in use',
    dialogTitle: 'Please check another email to register with!',
  );
}




