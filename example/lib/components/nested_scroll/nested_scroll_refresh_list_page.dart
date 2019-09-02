import 'package:example/widgets/refresh_pageable_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NestedScrollRefreshListPage extends StatefulWidget {
  const NestedScrollRefreshListPage({
    Key key,
    this.name,
  }) : super(key: key);

  final String name;

  @override
  State<StatefulWidget> createState() {
    return _NestedScrollRefreshListPageState();
  }
}

class TestModel extends RefreshPageableListModel<String> {
  static const int _pageSize = 10;
  int _pageIndex = 0;

  @override
  bool isEnd() {
    return _pageIndex >= 9;
  }

  @override
  Future<List<String>> onRefresh() async {
    print('onRefresh');
    await Future<void>.delayed(Duration(seconds: 10));
    _pageIndex = 0;
    List<String> result =
        List<String>.generate(_pageSize, (int index) => 'Index: $index');
    return result;
  }

  @override
  Future<List<String>> onPageable() async {
    print('onPageable: ${_pageIndex + 1}');
    await Future<void>.delayed(Duration(seconds: 10));
    _pageIndex++;
    List<String> result = List<String>.generate(
        _pageSize, (int index) => 'Index: ${_pageIndex * _pageSize + index}');
    return result;
  }

  @override
  Future<List<String>> onList() async {
    print('onList');
    await Future<void>.delayed(Duration(seconds: 10));
    _pageIndex = 0;
    List<String> result =
        List<String>.generate(_pageSize, (int index) => 'Index: $index');
    return result;
  }
}

class _NestedScrollRefreshListPageState
    extends State<NestedScrollRefreshListPage> {
  GlobalKey<RefreshPageableListViewState> _refreshKey = GlobalKey<RefreshPageableListViewState>();
  TestModel _model;

  @override
  void initState() {
    super.initState();
    _model = TestModel();
    print('page: 1');
  }

  @override
  Widget build(BuildContext context) {
    return RefreshPageableListView<String>(
      key: _refreshKey,
      model: _model,
      sliverHeaderBuilder: () => SliverOverlapInjector(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      ),
      sliverItemBuilder: (String item) => SliverToBoxAdapter(
        child: ListTile(
          title: Text(item),
        ),
      ),
      sliverFooterBuilder: (bool isEnd) => SliverToBoxAdapter(
        child: Container(
          alignment: AlignmentDirectional.center,
          height: kToolbarHeight,
          child: Text(isEnd ? '--- 我是有底线的 ---' : '加载中...'),
        ),
      ),
      physics: AlwaysScrollableScrollPhysics(),
      displacement: NestedScrollView.sliverOverlapAbsorberHandleFor(context)
              .layoutExtent +
          40.0,
      notificationCallback: (ScrollNotification notification) {
        if (notification is ScrollEndNotification) {
          int page = (notification.metrics.pixels /
                      _refreshKey.currentContext.size.height)
                  .roundToDouble()
                  .toInt() +
              1;
          print('page: $page');
        }
      },
    );
  }
}
