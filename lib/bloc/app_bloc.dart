import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kartoraeat/auth/auth_error.dart';
import 'package:kartoraeat/bloc/app_event.dart';
import 'package:kartoraeat/bloc/app_state.dart';

import '../utils/upload_image.dart';

class AppBloc extends Bloc<AppEvent ,AppState>{
  AppBloc()
      : super(
      AppStateLoggedOut(
        isLoading: false,
   ),
  ){
    on<AppEventGoToRegistration>((event, emit){
          emit(
            const AppStateIsInRegistrationView(
                isLoading: false
            ),
          );
        }
    );
    on<AppEventLogIn>((event, emit)async{
          emit( AppStateLoggedOut(
            isLoading: true,
          )
          );
          //register loogd the iser in
                try{
                  final email = event.email;
                  final password = event.password;
                  final userCredentials = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                      email: email,
                      password: password
                  );
                  final user = userCredentials.user;
                  final  images = await _getImages(user!.uid);
                  emit(
                    AppStateLoggedIn(
                        isLoading: false,
                        user: user,
                        images: images)
                  );
                }on FirebaseAuthException catch (e){
                  emit (AppStateLoggedOut(
                      isLoading: false,
                  authError: AuthError.from(e)));
                }
        }
    );
    on<AppEventGoToLogin>((event, emit){
          emit( AppStateLoggedOut(
            isLoading: false,
          )
          );
        }
    );
    on<AppEventRegister>((event ,emit)async{
      emit( const AppStateIsInRegistrationView(isLoading: true),
          );
          final email = event.email;
          final password = event.password;

          try{
            final credentials = await FirebaseAuth.instance
                .createUserWithEmailAndPassword(email: email,
                password: password
            );
            emit(AppStateLoggedIn(
                isLoading: false,
                user: credentials.user!,
                images: []));

          } on FirebaseAuthException catch (e) {
            emit(AppStateIsInRegistrationView(
                isLoading: false,
                authError: AuthError.from(e) ));
          }
        }
    );
    on<AppEventInitialize>((event, emit) async {
          final user = FirebaseAuth.instance.currentUser;
          if(user == null){
            emit(
               AppStateLoggedOut(isLoading: false)
            );
          } else {
            final images = await _getImages(user.uid);
            emit(
              AppStateLoggedIn(
                  isLoading: false,
                  user: user,
                  images: images)
            );
          }
        }
    );

    //log out event
    on<AppEventLogOut>((event, emit)async{
      emit(
          AppStateLoggedOut(
                isLoading: true,
              )
            );
      await FirebaseAuth.instance.signOut();
      emit(
        AppStateLoggedOut(
            isLoading: false
        ),
      );
    });
    //handle account deletion
    on<AppEventDeleteAccount>((event , emit) async{
          final user = FirebaseAuth.instance.currentUser;
          //log user out if user is not current user
            if(user == null){
              emit(AppStateLoggedOut(
                isLoading: false,
              )
              );
    return;
          }
            //start loading
          emit(
              AppStateLoggedIn(
                isLoading: true,
                user: user,
                images: state.images ?? [],
              )
          );
            //delete the user folder
          try{
            final folder = await FirebaseStorage.instance
                .ref(user.uid)
                .listAll();
              for(final item in folder.items){
              await item.delete().catchError((_) {}); // may be handle the error

            }
              await FirebaseStorage
            .instance
            .ref(user.uid)
            .delete()
            .catchError((_){});
              await user.delete();
              await FirebaseAuth.instance.signOut();
              //logged the user out in the UI
              emit(
                  AppStateLoggedOut(
                  isLoading: false
                  ),
              );
          } on FirebaseAuthException catch (e){

            emit(
                AppStateLoggedIn(
                  isLoading: false,
                  user: user,
                  images: state.images ?? [],
                  authError: AuthError.from(e),
                )
            );

          } on FirebaseException {
// we might not be able to delete the folder
          //log the user out
            emit(AppStateLoggedOut(
              isLoading: false,
            )
            );
          }
        }
    );
    on<AppEventUploadImage>((event, emit) async {
     final user = state.user;
     if(user == null){
       emit(AppStateLoggedOut(
             isLoading: false,)
       );
       return;
     }
// start the loading process
     emit(
         AppStateLoggedIn(
         isLoading: true,
         user: user,
         images: state.images ?? [],
         )
    );
        final file = File(event.filePathToUpload);
    await uploadImage(
        file: file,
        userId : user.uid,
    );
    //after upload is complete, grab the latest file references
  final images = await _getImages(user.uid);
  emit(
    AppStateLoggedIn(
      isLoading: false,
      user: user,
      images:images
    ),
  );
  }
    );
  }

  Future<Iterable<Reference>> _getImages(String userId) =>
      FirebaseStorage.instance
          .ref(userId)
          .list()
          .then((listResult) => listResult.items);
}