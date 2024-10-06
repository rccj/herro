import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class User {
  final String name;
  final int age;
  final String distance;
  final String imageUrl;
  final int id;

  User({required this.name, required this.age, required this.distance, required this.imageUrl, required this.id});
}

enum CardStatus { like, dislike, superLike }

class CardProvider with ChangeNotifier { 
  List<User> _users = [];
  bool _isDragging = false;
  double _angle = 0;
  Offset _position = Offset.zero;
  Size _screenSize = Size.zero;

  List<User> get users => _users;
  bool get isDragging => _isDragging;
  Offset get position => _position;
  double get angle => _angle;

  CardProvider() {
    resetUsers();
  }

 
  void setScreenSize(Size size) {
    _screenSize = size;
  }

  void startPosition(DragStartDetails details) {
    _isDragging = true;
    notifyListeners();
  }

  void updatePosition(DragUpdateDetails details) {
    _position += details.delta;
    final x = _position.dx;
    _angle = 45 * x / _screenSize.width;
    notifyListeners();
  }

  void endPosition(DragEndDetails details) {  
    _isDragging = false;
    notifyListeners();
    final status = getStatus();

    switch(status) {
      case CardStatus.like:
        like();
        _nextCard();
        break;
      case CardStatus.dislike:
        dislike();
        _nextCard();
        break;
      case CardStatus.superLike:
        superLike();
        _nextCard();
        break;
      default:
        resetPosition();
    }
  }

  void resetPosition() {
    _isDragging = false;
    _position = Offset.zero;
    _angle = 0;
    notifyListeners();
  }

  CardStatus? getStatus() {
    final x = _position.dx;
    final y = _position.dy;
    final forceSuperLike = x.abs() < 20;

    final delta = 100;
    if (x >= delta) {
      return CardStatus.like;
    } else if (x <= -delta) {
      return CardStatus.dislike;
    } else if (y <= -delta / 2 && forceSuperLike) {
      return CardStatus.superLike;
    }
  }


   void like() {
    _angle = 20;
    _position += Offset(2 * _screenSize.width, 0);
    notifyListeners();
  }

  void dislike() {
    _angle = -20;
    _position -= Offset(2 * _screenSize.width, 0);
  }

  void superLike() {
    _angle = 0;
    _position -= Offset(0,  _screenSize.width);
  }

  Future _nextCard() async {
    if (_users.isEmpty) return;

    await Future.delayed(Duration(milliseconds: 200));
    _users.removeLast();
    resetPosition();
  }

  void resetUsers() {
    _users = [
      User(name: "Alice", age: 25, distance: "5 km", imageUrl: 'https://picsum.photos/id/1001/1000/1500', id: 1),
      User(name: "Bob", age: 28, distance: "3 km", imageUrl: 'https://picsum.photos/id/1002/1000/1500', id: 2),
      User(name: "Charlie", age: 23, distance: "7 km", imageUrl: 'https://picsum.photos/id/1003/1000/1500', id: 3),
      User(name: "Diana", age: 26, distance: "2 km", imageUrl: 'https://picsum.photos/id/1004/1000/1500', id: 4),
      User(name: "Ethan", age: 30, distance: "10 km", imageUrl: 'https://picsum.photos/id/1005/1000/1500', id: 5),
    ].reversed.toList();

    notifyListeners();
  }
}