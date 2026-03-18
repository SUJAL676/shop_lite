import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:shop_lite/features/favorites/data/fav_model.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final box = Hive.box('favorites_box');

  FavoritesBloc() : super(FavoritesLoaded([])) {
    on<LoadFavorites>(_loadFavorites);
    on<ToggleFavorite>(_toggleFavorite);
  }

  void _loadFavorites(LoadFavorites event, Emitter<FavoritesState> emit) {
    final items = box.values.map((e) => FavoriteItem.fromMap(e)).toList();

    emit(FavoritesLoaded(items));
  }

  void _toggleFavorite(ToggleFavorite event, Emitter<FavoritesState> emit) {
    final exists = box.get(event.item.id);

    if (exists != null) {
      box.delete(event.item.id);
    } else {
      box.put(event.item.id, event.item.toMap());
    }
    final updatedItems = box.values
        .map((e) => FavoriteItem.fromMap(Map<String, dynamic>.from(e)))
        .toList();

    emit(FavoritesLoaded(updatedItems));
  }
}
