import 'package:flutter/material.dart';
import 'package:konwyou/screens/card_provider.dart';
import 'package:provider/provider.dart';
import 'dart:math' show pi;

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({Key? key}) : super(key: key);

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final size = MediaQuery.of(context).size;
      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.setScreenSize(size);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.red.shade200,
            Colors.black,
          ],
        )),
        child: Scaffold(
          appBar: AppBar(
            title: Text('探索'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Expanded(child: buildCards()),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: buildButtons(),
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildCards() {
    final provider = Provider.of<CardProvider>(context);
    final users = provider.users;

    return users.isEmpty
        ? Center(
            child: (ElevatedButton(
                child: Text('🥲'),
                onPressed: () {
                  final provider =
                      Provider.of<CardProvider>(context, listen: false);
                  provider.resetUsers();
                })))
        : Stack(
            children: users
                .map((user) => users.last.id == user.id
                    ? buildFrontCard(user)
                    : buildCard(user))
                .toList(),
          );
  }

  Widget buildFrontCard(User user) {
    return GestureDetector(
      key: ValueKey(user.id),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final provider = Provider.of<CardProvider>(context);
          final position = provider.position;
          final milliseconds = provider.isDragging ? 0 : 400;

          final center = constraints.smallest.center(Offset.zero);
          final angle = provider.angle * pi / 180;
          final rotatedMatrix = Matrix4.identity()
            ..translate(center.dx, center.dy)
            ..rotateZ(angle)
            ..translate(-center.dx, -center.dy);

          return AnimatedContainer(
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: milliseconds),
            transform: rotatedMatrix..translate(position.dx, position.dy),
            child: Stack(
              children: [
                buildCard(user),
                buildStamps(user),
              ],
            ),
          );
        },
      ),
      onPanStart: (details) {
        final provider = Provider.of<CardProvider>(context, listen: false);
        provider.startPosition(details);
      },
      onPanUpdate: (details) {
        final provider = Provider.of<CardProvider>(context, listen: false);
        provider.updatePosition(details);
      },
      onPanEnd: (details) {
        final provider = Provider.of<CardProvider>(context, listen: false);
        provider.endPosition(details);
      },
    );
  }

  Widget buildCard(User user) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(user.imageUrl),
              fit: BoxFit.cover,
              alignment: Alignment(-0.3, 0),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter,
              stops: [0.7, 1],
            )),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.name}, ${user.age}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        user.description,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButtons() {
    final provider = Provider.of<CardProvider>(context);
    final users = provider.users;
    final status = provider.getStatus();
    final isLike = status == CardStatus.like;
    final isDislike = status == CardStatus.dislike;
    final isSuperLike = status == CardStatus.superLike;

    return users.isEmpty
        ? ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text('Restart'),
            onPressed: () {
              final provider =
                  Provider.of<CardProvider>(context, listen: false);
              provider.resetUsers();
            },
          )
        : Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ElevatedButton(
              style: ButtonStyle(
                foregroundColor: getColor(Colors.red, Colors.white, isDislike),
                backgroundColor: getColor(Colors.white, Colors.red, isDislike),
                side: getBorder(Colors.red, Colors.white, isDislike),
              ),
              child: Icon(Icons.clear, size: 36),
              onPressed: () {
                final provider =
                    Provider.of<CardProvider>(context, listen: false);
                provider.dislike();
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                foregroundColor:
                    getColor(Colors.blue, Colors.white, isSuperLike),
                backgroundColor:
                    getColor(Colors.white, Colors.blue, isSuperLike),
                side: getBorder(Colors.blue, Colors.white, isSuperLike),
              ),
              child: Icon(Icons.star, size: 36),
              onPressed: () {
                final provider =
                    Provider.of<CardProvider>(context, listen: false);
                provider.superLike();
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                foregroundColor: getColor(Colors.green, Colors.white, isLike),
                backgroundColor: getColor(Colors.white, Colors.green, isLike),
                side: getBorder(Colors.green, Colors.white, isLike),
              ),
              child: Icon(Icons.favorite, size: 36),
              onPressed: () {
                final provider =
                    Provider.of<CardProvider>(context, listen: false);
                provider.like();
              },
            ),
          ]);
  }

  Widget buildStamps(User user) {
    final provider = Provider.of<CardProvider>(context);
    final status = provider.getStatus();
    final opacity = provider.getStatusOpacity();

    switch (status) {
      case CardStatus.like:
        final child = buildStamp(
            angle: -0.5, color: Colors.green, text: 'LIKE', opacity: opacity);
        return Positioned(
          top: 64,
          left: 50,
          child: child,
        );
      case CardStatus.dislike:
        final child = buildStamp(
            angle: 0.5, color: Colors.red, text: 'NOPE', opacity: opacity);
        return Positioned(
          top: 64,
          right: 50,
          child: child,
        );
      case CardStatus.superLike:
        final child = Center(
          child: buildStamp(
              angle: 0,
              color: Colors.blue,
              text: 'SUPER\nLIKE',
              opacity: opacity),
        );
        return Positioned(
          bottom: 128,
          left: 0,
          right: 0,
          child: child,
        );
      default:
        return Container();
    }
  }

  Widget buildStamp({
    double angle = 0,
    required Color color,
    required String text,
    required double opacity,
  }) {
    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color, width: 4),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  WidgetStateProperty<Color> getColor(
      Color color, Color colorPressed, bool force) {
    getColor(Set<WidgetState> states) {
      if (force || states.contains(WidgetState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    }

    return WidgetStateProperty.resolveWith(getColor);
  }

  WidgetStateProperty<BorderSide> getBorder(
      Color color, Color colorPressed, bool force) {
    getBorder(Set<WidgetState> states) {
      if (force || states.contains(WidgetState.pressed)) {
        return BorderSide(color: Colors.transparent);
      } else {
        return BorderSide(color: color, width: 2);
      }
    }

    return WidgetStateProperty.resolveWith(getBorder);
  }
}
