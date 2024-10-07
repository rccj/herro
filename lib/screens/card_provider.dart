import 'dart:math';

import 'package:flutter/material.dart';

class User {
  final String name;
  final int age;
  final String description;
  final String imageUrl;
  final int id;

  User({required this.name, required this.age, required this.description, required this.imageUrl, required this.id});
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
    final status = getStatus(force: true);

    switch(status) {
      case CardStatus.like:
        like();
        break;
      case CardStatus.dislike:
        dislike();
        break;
      case CardStatus.superLike:
        superLike();
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

  double getStatusOpacity() {
    final delta = 100;
    final pos = max(_position.dx.abs(), _position.dy.abs());
    final opacity = pos / delta;
    return min(opacity, 1);
  }

  CardStatus? getStatus({bool force = false}) {
    final x = _position.dx;
    final y = _position.dy;
    final delta = force ? 100 : 20;
    final forceSuperLike = x.abs() < 20;

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
    _nextCard();
    notifyListeners();
  }

  void dislike() {
    _angle = -20;
    _position -= Offset(2 * _screenSize.width, 0);
    _nextCard();
    notifyListeners();
  }

  void superLike() {
    _angle = 0;
    _position -= Offset(0,  _screenSize.width);
    _nextCard();
    notifyListeners();
  }

  Future _nextCard() async {
    if (_users.isEmpty) return;

    await Future.delayed(Duration(milliseconds: 200));
    _users.removeLast();
    resetPosition();
  }

  void resetUsers() {
    _users = [
      User(name: "Alice", age: 25, description: "Hi", imageUrl: 'https://picsum.photos/id/1001/1000/1500', id: 1),
      User(name: "Bob", age: 28, description: "Hello", imageUrl: 'https://picsum.photos/id/1002/1000/1500', id: 2),
      User(name: "Charlie", age: 23, description: "你好", imageUrl: 'https://picsum.photos/id/1003/1000/1500', id: 3),
      User(name: "Diana", age: 26, description: "烏拉", imageUrl: 'https://picsum.photos/id/1004/1000/1500', id: 4),
      User(name: "Ethan", age: 30, description: "呀～～～", imageUrl: 'https://picsum.photos/id/1005/1000/1500', id: 5),
    ].reversed.toList();

    notifyListeners();
  }
}