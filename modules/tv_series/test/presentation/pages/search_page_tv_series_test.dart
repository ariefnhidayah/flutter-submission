import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/tv_series.dart';

import '../../helpers/search_tv_series_bloc.mocks.dart';

void main() {
  final mockSearchTvSeriesBloc = MockSearchTvSeriesBloc();

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<SearchTvSeriesBloc>(
      create: (context) => mockSearchTvSeriesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
    'Page should display center progress bar when loading',
    (tester) async {
      when(() => mockSearchTvSeriesBloc.state).thenReturn(SearchTvSeriesLoading());

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);
      await tester.pumpWidget(makeTestableWidget(const SearchPageTvSeries()));

      expect(centerFinder, findsWidgets);
      expect(progressBarFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Page should display ListView when data is loaded',
    (tester) async {
      when(() => mockSearchTvSeriesBloc.state).thenReturn(const SearchTvSeriesHasData([]));

      final listViewFinder = find.byType(ListView);
      await tester.pumpWidget(makeTestableWidget(const SearchPageTvSeries()));

      expect(listViewFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Page should display text with message when Error',
    (tester) async {
      when(() => mockSearchTvSeriesBloc.state)
          .thenReturn(const SearchTvSeriesError('Error Message'));

      final textFinder = find.byKey(const Key('error_message'));
      await tester.pumpWidget(makeTestableWidget(const SearchPageTvSeries()));

      expect(textFinder, findsOneWidget);
    },
  );
}
