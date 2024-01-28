import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetDetailSeason usecase;
  late MockTvSeriesRepository repository;

  setUp(() {
    repository = MockTvSeriesRepository();
    usecase = GetDetailSeason(repository);
  });

  const tvSeriesID = 1;
  const seasonNumber = 1;

  test('should get tv season detail from the repository', () async {
    // arrange
    when(repository.getSeasonDetail(tvSeriesID, seasonNumber))
        .thenAnswer((_) async => const Right(testSeasonDetail));
    // act
    final result = await usecase.execute(tvSeriesID, seasonNumber);
    // assert
    expect(result, const Right(testSeasonDetail));
  });
}
