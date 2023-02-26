import 'dart:io';

import 'package:chat/common/utils/utils.dart';
import 'package:chat/features/news/controller/news_controller.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  static const routeName = '/add_post_screen';
  const AddPostTypeScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  File? image;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void storePost() {
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();

    if (title.isNotEmpty) {
      try {
        if (isLoading == false) {
          setState(() {
            isLoading = true;
          });
          ref.read(addPostControllerProvider).savePostDataToFirebase(
                context,
                title,
                description,
                image,
              );
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
            context: context,
            content:
                'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.');
        return;
      }
      ;
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context: context, content: 'Не указано название новости');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Создать новость'),
        actions: [
          TextButton(
            onPressed: storePost,
            child: const Text(
              'Создать',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            isLoading
                ? const LinearProgressIndicator()
                : const Padding(padding: EdgeInsets.only(top: 0.0)),
            const Divider(color: Colors.black26),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                filled: true,
                hintText: 'Введите название',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(18),
              ),
              maxLength: 30,
            ),
            const Divider(color: Colors.black26),
            GestureDetector(
              onTap: selectImage,
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(10),
                dashPattern: const [10, 4],
                strokeCap: StrokeCap.round,
                color: Colors.black,
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: image != null
                      ? Image.file(image!)
                      : const Center(
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 40,
                          ),
                        ),
                ),
              ),
            ),
            const Divider(color: Colors.black26),
            Expanded(
              child: TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  filled: true,
                  hintText: 'Введите описание',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(18),
                ),
                maxLines: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
