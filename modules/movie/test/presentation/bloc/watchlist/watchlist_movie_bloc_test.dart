import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';

import 'watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late WatchlistMovieBloc watchlistMovieBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    watchlistMovieBloc = WatchlistMovieBloc(mockGetWatchlistMovies);
  });

  test('initial state should be empty', () {
    expect(watchlistMovieBloc.state, WatchlistMovieEmpty());
  });

  final tMovieModel = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: const [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tMovieList = <Movie>[tMovieModel];

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'should emit [Loading, Has Data] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return watchlistMovieBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistMovie()),
    expect: () => [
      WatchlistMovieLoading(),
      WatchlistMovieHasData(tMovieList),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
    },
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'should emit [Loading, Error] when data is gotten unsuccessfully',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return watchlistMovieBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistMovie()),
    expect: () => [
      WatchlistMovieLoading(),
      const WatchlistMovieError("Server Failure"),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
    },
  );
}
