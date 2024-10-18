import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/screens/home_provider.dart';

void showAddToDoTaskDialogBox(BuildContext context, HomeProvider provider,
    {bool edit = false, int? index}) {
  showDialog(
    context: context,
    builder: (context) {
      return ChangeNotifierProvider<HomeProvider>.value(
        value: provider,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.1,
          ),
          child: AlertDialog(
            title: Text('Add To Do Task'),
            content: Form(
              key: provider.formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: provider.titleController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the title';
                        }
                        return null;
                      },
                      enabled: provider.state != ViewState.creating,
                      maxLength: 50,
                      maxLines: null,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (provider.formKey.currentState!.validate()) {
                          if (edit && index != null) {
                            provider.updateTask(index);
                          } else {
                            provider.storeTask();
                          }
                          if (context.mounted) {
                            Navigator.pop(context);
                            provider.titleController.clear();
                          }
                        }
                      },
                      child: provider.state == ViewState.creating
                          ? const CircularProgressIndicator()
                          : Text(edit ? 'Edit' : 'Add'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
