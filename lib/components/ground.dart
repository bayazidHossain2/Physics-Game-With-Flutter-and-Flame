import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:forge2d_game/components/body_component_with_user_data.dart';

const groundSize = 7.0;

class Ground extends BodyComponentWithUserData{
  Ground(Vector2 position, Sprite sprite)
    :super(
      renderBody: false,
      bodyDef: BodyDef()
        ..position = position
        ..type = BodyType.static,
      fixtureDefs: [
        FixtureDef(
          PolygonShape()..setAsBoxXY(groundSize / 2, groundSize / 2),
          friction: 0.3,
        )
      ],
      children: [
        SpriteComponent(
          anchor: Anchor.center,
          sprite: sprite,
          size: Vector2.all(groundSize),
          position: Vector2(0,0),

        )
      ]
    );
}