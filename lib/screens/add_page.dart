import 'package:flutter/material.dart';
import '/services/todo_services.dart';
import '/helper/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({
    super.key,
    this.todo,
  });

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Todo' : 'Add Todo',
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                isEdit ? 'Update' : 'submit',
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> updateData() async {
    //menangkap data
    final todo = widget.todo;
    if (todo == null) {
      print('Tidak Bisa Memperbarui data kosong');
      return;
    }
    final id = todo['_id'];

    //submit data update ke dalam server
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final isSuccess = await TodoService.updateTodo(id, body);

    //menampilkan pesan update sukses atau gagal berdasarkan status
    if (isSuccess) {
      showSuccessMessage(context, message: 'Berhasil Mengupdate Kegiatan');
    } else {
      showErrorMessage(context, message: 'Gagal Mengupdate Kegiatan');
    }
  }

  Future<void> submitData() async {
    //submit data ke dalam server
    final isSuccess = await TodoService.addTodo(body);

    //menampilkan pesan sukses atau gagal berdasarkan status
    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage(context, message: 'Kegiatan ditambahkan');
    } else {
      showErrorMessage(context, message: 'Isi Terlebih Dahulu!!');
    }
  }

  Map get body {
    // get data from form (server)
    final title = titleController.text;
    final description = descriptionController.text;
    return {"title": title, "description": description, "is_completed": false};
  }
}
