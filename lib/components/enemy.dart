import 'dart:math';

import 'package:characters/characters.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:forge2d_game/components/body_component_with_user_data.dart';

const enemySize = 5.0;

enum EnemeyColor {
  pink(color: 'pink', boss: false),
  blue(color: 'blue', boss: false),
  green(color: 'green', boss: false),
  yellow(color: 'yellow', boss: false),
  pinkBoss(color: 'pink', boss: true),
  blueBoss(color: 'blue', boss: true),
  greenBoss(color: 'green', boss: true),
  yellowBoss(color: 'yellow', boss: true);

  final bool boss;
  final String color;

  const EnemeyColor({required this.color, required this.boss});

  static EnemeyColor get randomColor =>
      EnemeyColor.values[Random().nextInt(EnemeyColor.values.length)];

  String get fileName =>
      'alien${color.capitalize}_${boss ? 'suit' : 'square'}.png';
}

class Enemy extends BodyComponentWithUserData with ContactCallbacks {
  Enemy(Vector2 position, Sprite sprite)
      : super(
          renderBody: false,
          bodyDef: BodyDef()
            ..position = position
            ..type = BodyType.dynamic,
          fixtureDefs: [
            FixtureDef(
              PolygonShape()..setAsBoxXY(enemySize / 2, enemySize / 2),
              friction: 0.3,
            )
          ],
          children: [
            SpriteComponent(
              anchor: Anchor.center,
              sprite: sprite,
              size: Vector2.all(enemySize),
              position: Vector2(0, 0),
            ),
          ],
        );

  @override
  void beginContact(Object other, Contact contact) {
    var interceptVelocity =
        (contact.bodyA.linearVelocity - contact.bodyB.linearVelocity)
            .length
            .abs();
    print('-_-_-_-_-_- $interceptVelocity');
    if (interceptVelocity > 35) {
      removeFromParent();
    }

    super.beginContact(other, contact);
  }

  @override
  update(double dt){
    super.update(dt);

    if(position.x > camera.visibleWorldRect.right +10 ||
    position.x < camera.visibleWorldRect.left -10){
      removeFromParent();
    }
  }
}

extension on String {
  String get capitalize =>
      characters.first.toUpperCase() + characters.skip(1).toLowerCase().join();
}
