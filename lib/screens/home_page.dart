import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:to_do_list/components/add_to_do_task.dart';
import 'package:to_do_list/components/to_do_tile.dart';
import 'package:to_do_list/screens/home_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<HomeProvider>(context, listen: false);
      provider.getTaskList();
    });
    super.initState();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('To Do App'),
      ),
      body: SmartRefresher(
        onLoading: () {
          provider.getTaskList(loadMore: true);
          _refreshController.loadComplete();
        },
        onRefresh: () {
          provider.getTaskList();
          _refreshController.refreshCompleted();
        },
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            return const CircularProgressIndicator();
          },
        ),
        controller: _refreshController,
        header: const WaterDropHeader(),
        child: ListView(
          shrinkWrap: true,
          children: [
            provider.state == ViewState.loading
                ? Container(
                    height: MediaQuery.of(context).size.height / 1.5,
                    alignment: Alignment.center,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : provider.tasks.isEmpty
                    ? Container(
                        height: MediaQuery.of(context).size.height / 1.5,
                        alignment: Alignment.center,
                        child: Text(
                          'No Record found!',
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          final item = provider.tasks[index];
                          return ToDoTile(
                            title: item.title ?? 'NA',
                            isCompleted: item.isCompleted ?? false,
                            onChanged: (val) {
                              provider.updateTask(index, isCompleted: true);
                            },
                            popMenu: provider.state == ViewState.deleting
                                ? const CircularProgressIndicator()
                                : PopupMenuButton(
                                    itemBuilder: (context) => [
                                      if (item.isCompleted != true)
                                        PopupMenuItem(
                                          child: Text('Edit'),
                                          value: 1,
                                        ),
                                      PopupMenuItem(
                                        child: Text('Delete'),
                                        value: 2,
                                      ),
                                    ],
                                    onSelected: (val) {
                                      if (val == 1) {
                                        provider.titleController.text =
                                            item.title ?? '';
                                        showAddToDoTaskDialogBox(
                                          context,
                                          provider,
                                          edit: true,
                                          index: index,
                                        );
                                      }
                                      if (val == 2 && item.id != null) {
                                        provider.deleteTask(item.id!);
                                      }
                                    },
                                  ),
                          );
                        },
                        shrinkWrap: true,
                        itemCount: provider.tasks.length,
                        physics: const NeverScrollableScrollPhysics(),
                      ),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          showAddToDoTaskDialogBox(context, provider);
        },
        child: RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                child: Icon(Icons.add),
                alignment: PlaceholderAlignment.middle,
              ),
              TextSpan(
                text: 'Add Task',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
