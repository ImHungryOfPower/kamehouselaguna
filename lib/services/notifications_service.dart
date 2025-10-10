class NotificationsService {
    bool _subscribed = false;
    bool get isSubscribed => _subscribed;


    Future<void> subscribe() async {
// TODO: Integrar proveedor real (FCM/OneSignal). Aquí solo mock.
        _subscribed = true;
        await Future<void>.delayed(const Duration(milliseconds: 200));
    }


    Future<void> unsubscribe() async {
        _subscribed = false;
        await Future<void>.delayed(const Duration(milliseconds: 200));
}
}