part of 'favorites_bloc.dart';

@immutable
sealed class FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<FavoriteItem> items;

  FavoritesLoaded(this.items);
}
