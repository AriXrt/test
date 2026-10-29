import 'package:hive/hive.dart';

import '../../domain/entities/movie.dart';

/// Ручной TypeAdapter для [Movie] — без code generation и build_runner.
///
/// Порядок индексов полей фиксирован: менять его можно только с миграцией
/// уже сохранённых данных.
class MovieAdapter extends TypeAdapter<Movie> {
  @override
  final int typeId = 0;

  @override
  Movie read(BinaryReader reader) {
    final int fieldsCount = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < fieldsCount; i++) reader.readByte(): reader.read(),
    };

    return Movie(
      id: fields[0] as int,
      title: fields[1] as String,
      overview: fields[2] as String,
      posterUrl: fields[3] as String,
      rating: (fields[4] as num).toDouble(),
      releaseYear: fields[5] as int,
      kinopoiskUrl: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Movie obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.overview)
      ..writeByte(3)
      ..write(obj.posterUrl)
      ..writeByte(4)
      ..write(obj.rating)
      ..writeByte(5)
      ..write(obj.releaseYear)
      ..writeByte(6)
      ..write(obj.kinopoiskUrl);
  }
}
