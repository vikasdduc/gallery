import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kartoraeat/bloc/app_bloc.dart';
import 'package:kartoraeat/bloc/app_event.dart';
import 'package:kartoraeat/bloc/app_state.dart';
import 'package:kartoraeat/views/main_popup_menu.dart';
import 'package:kartoraeat/views/storage_image_widget.dart';

class PhotoGalleryView extends HookWidget {
  const PhotoGalleryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final picker = useMemoized(() => ImagePicker(), [key]);
    final images = context.watch<AppBloc>().state.images ?? [] ;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Photo Gallery'
        ),
        actions: [
          IconButton(
              onPressed: () async{
            final image = await picker.pickImage(
                source: ImageSource.gallery
            );
            if(image == null){
              return;
            }
            context.read()<AppBloc>().add(
              AppEventUploadImage(filePathToUpload: image.path),
            );
          }, icon: Icon(
              Icons.upload)),
          MainPopupMenuButton()
        ],
      ),
      body: GridView.count(
          crossAxisCount: 2,
        padding: EdgeInsets.all(8),
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 20.0,
        children: images
               .map(
                (img) => StorageImageView(
                    image: img,
                ),
        ).toList(),
      ),
    );
  }
}
