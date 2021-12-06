import 'package:my_f_app/providers/events_slider_api_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:my_f_app/domain/event_slider.dart';

// просто методы упраления списком эвентов подгрузить удалить И _eventsApi http запрос отдельн класс
class EventBrowseService {
  final _eventsApi = EventsSliderApiProvider(); // HTTP ЗАПРОС ЗДЕСЬ!!
  static final EventBrowseService _instance = EventBrowseService
      ._internal(); // The _internal construction is just a name often given to constructors that are private to the class
  //we must create the object manually and return it and then in factory see below

  //Storage a queue or more precisely a reverse queue you can figure that on your own
  //Hint : reverse queue + stack ?
  final eventsBrowsed = BehaviorSubject<
      List<
          EventSlider>>(); // "Левая" сторона конвейерной ленты, где вы помещаете данные в Stream. = новый стрим контроллер
//С BehaviourSubject каждый новый подписчик получит сперва последнее принятое значение:

  //If you want to show loading status in case your queue is empty
  final browsedLoading = BehaviorSubject<bool>.seeded(false);
  EventBrowseService._internal();

  factory EventBrowseService() =>
      _instance; // The => expr syntax is a shorthand for { return expr; }
  // factory использовать и возвращать из конструктора уже имеющийся объект. _instance как раз статичный
  // Factory constructors are much like normal static methods

  void _maybeBrowseMore() {
    // Fetch fresh ones when two or less remaining after swipe
    List<EventSlider> browsed = eventsBrowsed.value;
    if (browsed.length <= 3) {
      browseEvents();
    }
  }

  Future<List<EventSlider>> browseMoreEvents() async {
    List<EventSlider> browsedEvents = await _eventsApi
        .getEvents(); // асинхронные методы, таких как чтение данных из баз данных
    return browsedEvents; // await позволяет дождаться выполнения асинхронной функции и после обработать результат, фун async
  }

  Future<void> browseEvents() async {
    browsedLoading.add(true);
    List<EventSlider> events = await browseMoreEvents(); // запросить еще из БД
    _addMoreEventsToQueue(events);
    browsedLoading.add(false);
  }

  // Adds new brosed events -- duplicates allowed
  void _addMoreEventsToQueue(List<EventSlider> browsed) {
    List<EventSlider> eventsInList =
        eventsBrowsed.valueOrNull ?? <EventSlider>[]; // что было
    print("Added ${browsed.length} more events");
    eventsBrowsed.add(browsed +
        eventsInList); // ??? зачем добавлять тех которые были мб тк это BehaviorSubject?
  }

  void _removeFromBrowsedEventByIndex(int swipedOn) {
    List<EventSlider> browsed = eventsBrowsed.value;
    browsed.removeAt(swipedOn);
    eventsBrowsed.add(
        browsed); // опять зачем добавлять что было в спсике??? мб тк это BehaviorSubject?
    _maybeBrowseMore();
  }

  Future<void> swipedLeft(int index, EventSlider event) async {
    assert(eventsBrowsed.valueOrNull !=
        null); // disrupt normal execution if a boolean condition is false
    _removeFromBrowsedEventByIndex(index);
    print("After Swiping Left ${eventsBrowsed.valueOrNull.length}");
  }
//
// Future<void> swipedRight(int index, Event event) async {
//   assert(eventsBrowsed.valueOrNull != null);
//   _removeFromBrowsedEventByIndex(index);
//   print("After Swiping Right ${eventsBrowsed.valueOrNull!.length}");
// }
}
