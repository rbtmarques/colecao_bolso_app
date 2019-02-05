import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/common.dart';
import 'bloc/bloc.dart';
import 'collections_list_tile.dart';

class CollectionsList extends StatefulWidget {
  final CollectionsBloc _collectionsBloc;

  CollectionsList(this._collectionsBloc)
      : assert(_collectionsBloc != null);

  _CollectionsListState createState() => _CollectionsListState();
}

class _CollectionsListState extends State<CollectionsList> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  _CollectionsListState() {
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      widget._collectionsBloc.dispatch(CollectionsFetchEvent());
    }
  }

  Widget _buildList(CollectionsLoadedState state) {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index >= state.data.length) {
          return BottomLoader();
        }

        return CollectionsListTile(state.data[index], widget._collectionsBloc);
      },
      itemCount:
          state.hasReachedMax ? state.data.length : state.data.length + 1,
      controller: _scrollController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionsEvent, CollectionsState>(
      bloc: widget._collectionsBloc,
      builder: (BuildContext context, CollectionsState state) {
        if (state is CollectionsLoadingState) {
          return ShimmerList();
        }

        if (state is CollectionsErrorState) {
          return Empty(
            text: Text(state.error),
          );
        }

        if (state is CollectionsLoadedState) {
          if (state.data.isEmpty) {
            return Empty(
              text: Text('Você ainda não cadastrou nenhuma coleção.'),
            );
          }
          return _buildList(state);
        }
      },
    );

    // return ScopedModelDescendant(
    //   builder: (BuildContext context, Widget child, CollectionModel model) {
    //     Widget content = Empty();

    //     if (model.collections.length > 0 && !model.isLoading) {
    //       content = _buildList();
    //     } else if (model.collections.length == 0 && !model.isLoading) {
    //       content = content;
    //     } else if (model.isLoading) {
    //       content = ShimmerList();
    //     }
    //     return RefreshIndicator(
    //       child: content,
    //       onRefresh: model.fetch,
    //     );
    //   },
    // );
  }
}
