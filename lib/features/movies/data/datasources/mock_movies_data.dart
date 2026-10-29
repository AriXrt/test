import '../../domain/entities/movie.dart';

/// Постер с CDN Яндекса (инфраструктура Кинопоиска), отдаёт JPEG без редиректов.
String _posterUrl(int kpId) =>
    'https://st.kp.yandex.net/images/film_iphone/iphone360_$kpId.jpg';

/// Страница фильма на Кинопоиске.
String _kinopoiskUrl(int kpId) => 'https://www.kinopoisk.ru/film/$kpId/';

/// Единая точка создания фильма: id = kpId, ссылки выводятся из него.
Movie _movie({
  required int kpId,
  required String title,
  required String overview,
  required double rating,
  required int year,
}) {
  return Movie(
    id: kpId,
    title: title,
    overview: overview,
    posterUrl: _posterUrl(kpId),
    rating: rating,
    releaseYear: year,
    kinopoiskUrl: _kinopoiskUrl(kpId),
  );
}

/// 35 культовых фильмов из ТОП-250 Кинопоиска.
final List<Movie> mockMovies = List<Movie>.unmodifiable(<Movie>[
  _movie(kpId: 326, title: 'Побег из Шоушенка', overview: 'Банкир получает срок за чужое преступление и находит друга в тюрьме Шоушенк.', rating: 9.1, year: 1994),
  _movie(kpId: 435, title: 'Зелёная миля', overview: 'Тюремный надзиратель встречает заключённого с даром исцеления.', rating: 9.1, year: 1999),
  _movie(kpId: 389, title: 'Леон', overview: 'Одинокий киллер берёт под опеку девочку, чья семья погибла.', rating: 8.9, year: 1994),
  _movie(kpId: 447301, title: 'Начало', overview: 'Вор, крадущий идеи из снов, получает задание внедрить мысль в чужое сознание.', rating: 8.7, year: 2010),
  _movie(kpId: 258687, title: 'Интерстеллар', overview: 'Экипаж ищет новый дом для человечества за червоточиной.', rating: 8.7, year: 2014),
  _movie(kpId: 301, title: 'Матрица', overview: 'Хакер узнаёт, что окружающий мир — симуляция машин.', rating: 8.5, year: 1999),
  _movie(kpId: 535341, title: '1+1', overview: 'Парализованный аристократ нанимает сиделку из пригорода Парижа.', rating: 8.8, year: 2011),
  _movie(kpId: 1143242, title: 'Джентльмены', overview: 'Британский наркобарон пытается выгодно продать свою империю.', rating: 8.5, year: 2019),
  _movie(kpId: 111543, title: 'Тёмный рыцарь', overview: 'Бэтмен вступает в противостояние с Джокером — гением хаоса.', rating: 8.5, year: 2008),
  _movie(kpId: 342, title: 'Криминальное чтиво', overview: 'Пересекающиеся истории гангстеров, боксёра и грабителей.', rating: 8.6, year: 1994),
  _movie(kpId: 361, title: 'Бойцовский клуб', overview: 'Клерк и торговец мылом создают подпольный бойцовский клуб.', rating: 8.6, year: 1999),
  _movie(kpId: 448, title: 'Форрест Гамп', overview: 'Простак с добрым сердцем проживает эпоху ключевых событий XX века.', rating: 8.8, year: 1994),
  _movie(kpId: 474, title: 'Гладиатор', overview: 'Преданный генерал становится гладиатором и ищет мести.', rating: 8.6, year: 2000),
  _movie(kpId: 1048334, title: 'Паразиты', overview: 'Бедная семья постепенно проникает в дом богачей.', rating: 8.3, year: 2019),
  _movie(kpId: 725190, title: 'Одержимость', overview: 'Молодой барабанщик сталкивается с безжалостным наставником.', rating: 8.3, year: 2014),
  _movie(kpId: 8134, title: 'Иван Васильевич меняет профессию', overview: 'Машина времени отправляет управдома в XVI век к Ивану Грозному.', rating: 8.8, year: 1973),
  _movie(kpId: 7932, title: 'Служебный роман', overview: 'Скромный статистик влюбляется в строгую начальницу.', rating: 8.6, year: 1977),
  _movie(kpId: 8091, title: 'Операция «Ы» и другие приключения Шурика', overview: 'Три новеллы о находчивом студенте Шурике.', rating: 8.6, year: 1965),
  _movie(kpId: 8096, title: 'Кавказская пленница, или Новые приключения Шурика', overview: 'Студент спасает похищенную девушку на Кавказе.', rating: 8.6, year: 1966),
  _movie(kpId: 8114, title: 'Ирония судьбы, или С лёгким паром!', overview: 'По ошибке герой улетает в Ленинград и попадает к чужой невесте.', rating: 8.4, year: 1975),
  _movie(kpId: 6687, title: 'Москва слезам не верит', overview: 'Три подруги и их непростые судьбы в Москве.', rating: 8.4, year: 1979),
  _movie(kpId: 6872, title: 'Достучаться до небес', overview: 'Двое смертельно больных угоняют машину, чтобы увидеть море.', rating: 8.6, year: 1997),
  _movie(kpId: 472, title: 'Большой куш', overview: 'Бокс, бриллиант и криминальный Лондон в одной афере.', rating: 8.5, year: 2000),
  _movie(kpId: 395, title: 'Карты, деньги, два ствола', overview: 'Долги, покер и банда гангстеров с двумя стволами.', rating: 8.4, year: 1998),
  _movie(kpId: 45014, title: 'Вечное сияние чистого разума', overview: 'Пара решает стереть друг друга из памяти.', rating: 8.5, year: 2004),
  _movie(kpId: 397667, title: 'Остров проклятых', overview: 'Маршал расследует исчезновение пациентки в клинике для преступников.', rating: 8.6, year: 2010),
  _movie(kpId: 196481, title: 'Престиж', overview: 'Соперничество двух иллюзионистов доходит до крайности.', rating: 8.4, year: 2006),
  _movie(kpId: 191341, title: 'Отступники', overview: 'Крыса в полиции и крыса в банде играют в смертельную игру.', rating: 8.5, year: 2006),
  _movie(kpId: 328, title: 'Семь', overview: 'Детективы ищут маньяка, чьи убийства связаны с семью смертными грехами.', rating: 8.3, year: 1995),
  _movie(kpId: 59153, title: 'V значит Вендетта', overview: 'Боец в маске объявляет войну тоталитарному режиму.', rating: 8.3, year: 2005),
  _movie(kpId: 5219, title: 'Малышка на миллион', overview: 'Пожилой тренер берёт в ученицы целеустремлённую боксёршу.', rating: 8.4, year: 2004),
  _movie(kpId: 689, title: 'Гарри Поттер и философский камень', overview: 'Мальчик узнаёт, что он волшебник, и попадает в Хогвартс.', rating: 8.3, year: 2001),
  _movie(kpId: 414, title: 'Властелин колец: Братство Кольца', overview: 'Хоббит отправляется в путь, чтобы уничтожить Кольцо Всевластья.', rating: 8.6, year: 2001),
  _movie(kpId: 232, title: 'Терминатор 2: Судный день', overview: 'Терминатор защищает будущего лидера сопротивления.', rating: 8.5, year: 1991),
  _movie(kpId: 476, title: 'Назад в будущее', overview: 'Подросток случайно попадает в 1955 год на машине времени.', rating: 8.5, year: 1985),
]);
