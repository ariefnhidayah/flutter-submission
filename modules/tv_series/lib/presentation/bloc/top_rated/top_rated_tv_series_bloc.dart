import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:tv_series/tv_series.dart';

part 'top_rated_tv_series_event.dart';
part 'top_rated_tv_series_state.dart';

class TopRatedTvSeriesBloc
    extends Bloc<TopRatedTvSeriesEvent, TopRatedTvSeriesState> {
  final GetTopRatedTvSeries _getTopRatedTvSeries;

  TopRatedTvSeriesBloc(this._getTopRatedTvSeries)
      : super(TopRatedTvSeriesEmpty()) {
    on<TopRatedTvSeriesEvent>((event, emit) async {
      emit(TopRatedTvSeriesLoading());

      final result = await _getTopRatedTvSeries.execute();
      result.fold(
        (failure) {
          emit(TopRatedTvSeriesError(failure.message));
        },
        (data) {
          emit(TopRatedTvSeriesHasData(data));
        },
      );
    });
  }
}
