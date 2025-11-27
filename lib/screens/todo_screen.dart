import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_app/bloc/auth_bloc/bloc/auth_bloc.dart';
import 'package:testing_app/bloc/todo_bloc/todo_bloc.dart';
import 'package:testing_app/bloc/todo_bloc/todo_event.dart';
import 'package:testing_app/bloc/todo_bloc/todo_state.dart';
import 'package:testing_app/reuseable/alert_dialogue.dart';
import 'package:testing_app/reuseable/texformfield.dart';
import 'package:testing_app/screens/signin.dart';

class TodoScreen extends StatefulWidget {
  final String userUid;
  const TodoScreen(this.userUid, {super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final itemController = TextEditingController();
  final editingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _itemKey = GlobalKey<FormState>();
  final _editFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<TodoBloc>().add(LoadTodo(userId: widget.userUid));
  }

  @override
  void dispose() {
    itemController.dispose();
    editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSignOut) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Signin()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Sign Out Successfully'),
                  backgroundColor: Colors.green.shade400,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
          },
        ),
        BlocListener<TodoBloc, TodoState>(
          listener: (context, state) {
            if (state is TodoDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Todo Deleted Successfully'),
                  backgroundColor: Colors.green.shade400,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            } else if (state is TodoError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Something went wrong'),
                  backgroundColor: Colors.red.shade400,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                AppBar(
                  title: const Text(
                    'Todo app',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.1),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextButton(
                              onPressed: state is AuthLoading
                                  ? null
                                  : () {
                                      context.read<AuthBloc>().add(
                                        SignOutButtonClicked(),
                                      );
                                    },
                              child: state is AuthLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : const Text(
                                      'Sign Out',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: BlocBuilder<TodoBloc, TodoState>(
                      builder: (context, state) {
                        if (state is TodoLoading || state is TodoInitial) {
                          return const Center(
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Form(
                                        key: _itemKey,
                                        child: TexFormfield(
                                          controller: itemController,
                                          hintText: 'Enter todo title',
                                          labelText: const Text(
                                            'Title',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          prefixIcon: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          validator: (value) =>
                                              value == null || value.isEmpty
                                              ? 'Title required'
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Color(0xFF667eea),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      onPressed: state is TodoLoading
                                          ? null
                                          : () {
                                              if (_itemKey.currentState!
                                                  .validate()) {
                                                context.read<TodoBloc>().add(
                                                  AddTodo(
                                                    title: itemController.text,
                                                    userId: widget.userUid,
                                                    subtitle: DateTime.now()
                                                        .toIso8601String(),
                                                  ),
                                                );
                                                itemController
                                                    .clear(); // Clear after add
                                              }
                                            },
                                      child: const Text(
                                        'Add Item',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: state is TodoLoading
                                  ? const Center(
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    )
                                  : state is TodoLoaded
                                  ? state.todos.isEmpty
                                        ? Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.task_alt_outlined,
                                                  size: 64,
                                                  color: Colors.white
                                                      .withOpacity(0.6),
                                                ),
                                                const SizedBox(height: 16),
                                                const Text(
                                                  'No todos yet',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : ListView.builder(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            itemCount: state.todos.length,
                                            itemBuilder: (context, index) {
                                              Map<String, dynamic> todo =
                                                  state.todos[index];
                                              bool isComplete =
                                                  todo['isComplete'];

                                              return Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  border: Border.all(
                                                    color: Colors.white
                                                        .withOpacity(0.2),
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      blurRadius: 8,
                                                      offset: const Offset(
                                                        0,
                                                        2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: ListTile(
                                                  contentPadding:
                                                      const EdgeInsets.all(16),
                                                  leading: Checkbox(
                                                    activeColor: Colors.green,
                                                    checkColor: Colors.white,
                                                    value: isComplete,
                                                    onChanged: (value) {
                                                      context
                                                          .read<TodoBloc>()
                                                          .add(
                                                            ToggleTodo(
                                                              userId: widget
                                                                  .userUid,
                                                              docId: todo['id'],
                                                              toggleTodo: value,
                                                            ),
                                                          );
                                                    },
                                                  ),
                                                  title: Text(
                                                    todo['title'] ?? '',
                                                    style: TextStyle(
                                                      color: isComplete
                                                          ? Colors.grey.shade400
                                                          : Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      decoration: isComplete
                                                          ? TextDecoration
                                                                .lineThrough
                                                          : null,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    todo['createdAt'] ??
                                                        'No date',
                                                    style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.7),
                                                    ),
                                                  ),
                                                  trailing: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.blue
                                                              .withOpacity(0.2),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                        child: IconButton(
                                                          onPressed: () {
                                                            editingController
                                                                    .text =
                                                                todo['title'] ??
                                                                ''; // Pre-fill edit field
                                                            showDialog(
                                                              context: context,
                                                              builder: (context) => MyAlertDialog(
                                                                title:
                                                                    'Edit Todo',
                                                                content: Form(
                                                                  key:
                                                                      _editFormKey,
                                                                  child: TexFormfield(
                                                                    controller:
                                                                        editingController,
                                                                    hintText:
                                                                        'Edit your todo title',
                                                                    labelText:
                                                                        const Text(
                                                                          'Edit Title',
                                                                        ),
                                                                    prefixIcon: const Icon(
                                                                      Icons
                                                                          .edit,
                                                                      color: Colors
                                                                          .blue,
                                                                    ),
                                                                    validator: (value) =>
                                                                        value ==
                                                                                null ||
                                                                            value.isEmpty
                                                                        ? 'Title required'
                                                                        : null,
                                                                  ),
                                                                ),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.of(
                                                                          context,
                                                                        ).pop(),
                                                                    child: const Text(
                                                                      'Cancel',
                                                                    ),
                                                                  ),
                                                                  ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .blue,
                                                                      foregroundColor:
                                                                          Colors
                                                                              .white,
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              8,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                    onPressed: () {
                                                                      if (_editFormKey
                                                                          .currentState!
                                                                          .validate()) {
                                                                        context
                                                                            .read<
                                                                              TodoBloc
                                                                            >()
                                                                            .add(
                                                                              UpdateTodo(
                                                                                userId: widget.userUid,
                                                                                docId:
                                                                                    todo['id'] ??
                                                                                    todo['docId'], // Use correct id
                                                                                title: editingController.text,
                                                                                subtitle:
                                                                                    todo['subtitle'] ??
                                                                                    '',
                                                                              ),
                                                                            );
                                                                        Navigator.of(
                                                                          context,
                                                                        ).pop();
                                                                      }
                                                                    },
                                                                    child:
                                                                        const Text(
                                                                          'Save',
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                          icon: const Icon(
                                                            Icons.edit,
                                                            color: Colors.blue,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.red
                                                              .withOpacity(0.2),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                        child: IconButton(
                                                          onPressed: () {
                                                            showDialog(
                                                              context: context,
                                                              builder: (context) => MyAlertDialog(
                                                                title:
                                                                    'Delete Todo',
                                                                content: Text(
                                                                  'Are you sure you want to delete "${todo['title']}"?',
                                                                ),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.of(
                                                                          context,
                                                                        ).pop(),
                                                                    child: const Text(
                                                                      'Cancel',
                                                                    ),
                                                                  ),
                                                                  ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red,
                                                                      foregroundColor:
                                                                          Colors
                                                                              .white,
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              8,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                    onPressed: () {
                                                                      context
                                                                          .read<
                                                                            TodoBloc
                                                                          >()
                                                                          .add(
                                                                            DeleteTodo(
                                                                              userId: widget.userUid,
                                                                              docId:
                                                                                  todo['id'] ??
                                                                                  todo['docId'],
                                                                            ),
                                                                          );
                                                                      Navigator.of(
                                                                        context,
                                                                      ).pop();
                                                                    },
                                                                    child: const Text(
                                                                      'Delete',
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                          icon: const Icon(
                                                            Icons.delete,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                  : Container(),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
