import 'dart:math';


class RandomMessageService {
    static const _messages = [
        '¡Gracias por apoyar a KameHouse Laguna!',
        'Hoy es buen día para un unboxing en vivo.',
        'Tip: Activa notificaciones para no perder transmisiones.',
        'Nueva mercancía pronto, ¡estate al pendiente!',
    ];


    String next() {
        final rnd = Random();
        return _messages[rnd.nextInt(_messages.length)];
    }
}