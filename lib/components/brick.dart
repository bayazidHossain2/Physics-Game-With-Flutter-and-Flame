import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:forge2d_game/components/body_component_with_user_data.dart';

const brickScale = 0.5;

enum BrickType{
  explosive(density: 1, friction: 0.5),
  glass(density: 0.5, friction: 0.2),
  metal(density: 1, friction: 0.4),
  stone(density: 2, friction: 1),
  wood(density: 0.25, friction: 0.6);

  final double density;
  final double friction;

  const BrickType({required this.density, required this.friction});
  static BrickType get randomType => values[Random().nextInt(values.length)];
}

enum BrickSize{
  size70x70(ui.Size(70,70)),
  size140x70(ui.Size(140,70)),
  size220x70(ui.Size(220,70)),
  size70x140(ui.Size(70,140)),
  size140x140(ui.Size(140,140)),
  size220x140(ui.Size(220,140)),
  size140x220(ui.Size(140,220)),
  size70x220(ui.Size(70,220));

  final ui.Size size;

  const BrickSize(this.size);
  static BrickSize get randomSize => values[Random().nextInt(values.length)];
}

enum BrickDamage{none, some, lots}

Map<BrickDamage, String> brickFileNames(BrickType type, BrickSize size){
  return switch ((type, size)){
    (BrickType.explosive, BrickSize.size140x70)=>{
      BrickDamage.none: 'elementExplosive009.png',
      BrickDamage.some: 'elementExplosive012.png',
      BrickDamage.lots: 'elementExplosive050.png',
    },
    (BrickType.glass, BrickSize.size140x70)=> {
      BrickDamage.none: 'elementGlass010.png', 
      BrickDamage.some: 'elementGlass013.png',
      BrickDamage.lots: 'elementGlass048.png',
    },
    (BrickType.metal, BrickSize.size140x70) => {
      BrickDamage.none: 'elementMetal009.png',
      BrickDamage.some: 'elementMetal012.png',
      BrickDamage.lots: 'elementMetal050.png',
    },
    (BrickType.stone, BrickSize.size140x70) => {
      BrickDamage.none: 'elementStone009.png',
      BrickDamage.some: 'elementStone012.png',
      BrickDamage.lots: 'elementStone047.png',
    },
    (BrickType.wood, BrickSize.size140x70) => {
      BrickDamage.none: 'elementWood011.png',
      BrickDamage.some: 'elementWood014.png',
      BrickDamage.lots: 'elementWood054.png',
    },

    (BrickType.explosive, BrickSize.size70x70)=>{
      BrickDamage.none: 'elementExplosive011.png',
      BrickDamage.some: 'elementExplosive014.png',
      BrickDamage.lots: 'elementExplosive049.png',
    },
    (BrickType.glass, BrickSize.size70x70)=> {
      BrickDamage.none: 'elementGlass011.png', 
      BrickDamage.some: 'elementGlass012.png',
      BrickDamage.lots: 'elementGlass046.png',
    },
    (BrickType.metal, BrickSize.size70x70) => {
      BrickDamage.none: 'elementMetal011.png',
      BrickDamage.some: 'elementMetal014.png',
      BrickDamage.lots: 'elementMetal049.png',
    },
    (BrickType.stone, BrickSize.size70x70) => {
      BrickDamage.none: 'elementStone011.png',
      BrickDamage.some: 'elementStone014.png',
      BrickDamage.lots: 'elementStone046.png',
    },
    (BrickType.wood, BrickSize.size70x70) => {
      BrickDamage.none: 'elementWood018.png',
      BrickDamage.some: 'elementWood013.png',
      BrickDamage.lots: 'elementWood045.png',
    },

    (BrickType.explosive, BrickSize.size220x70)=>{
      BrickDamage.none: 'elementExplosive013.png',
      BrickDamage.some: 'elementExplosive016.png',
      BrickDamage.lots: 'elementExplosive051.png',
    },
    (BrickType.glass, BrickSize.size220x70)=> {
      BrickDamage.none: 'elementGlass014.png', 
      BrickDamage.some: 'elementGlass017.png',
      BrickDamage.lots: 'elementGlass049.png',
    },
    (BrickType.metal, BrickSize.size220x70) => {
      BrickDamage.none: 'elementMetal013.png',
      BrickDamage.some: 'elementMetal016.png',
      BrickDamage.lots: 'elementMetal051.png',
    },
    (BrickType.stone, BrickSize.size220x70) => {
      BrickDamage.none: 'elementStone013.png',
      BrickDamage.some: 'elementStone016.png',
      BrickDamage.lots: 'elementStone048.png',
    },
    (BrickType.wood, BrickSize.size220x70) => {
      BrickDamage.none: 'elementWood012.png',
      BrickDamage.some: 'elementWood015.png',
      BrickDamage.lots: 'elementWood047.png',
    },

    (BrickType.explosive, BrickSize.size70x140)=>{
      BrickDamage.none: 'elementExplosive017.png',
      BrickDamage.some: 'elementExplosive022.png',
      BrickDamage.lots: 'elementExplosive052.png',
    },
    (BrickType.glass, BrickSize.size70x140)=> {
      BrickDamage.none: 'elementGlass018.png', 
      BrickDamage.some: 'elementGlass023.png',
      BrickDamage.lots: 'elementGlass050.png',
    },
    (BrickType.metal, BrickSize.size70x140) => {
      BrickDamage.none: 'elementMetal017.png',
      BrickDamage.some: 'elementMetal023.png',
      BrickDamage.lots: 'elementMetal052.png',
    },
    (BrickType.stone, BrickSize.size70x140) => {
      BrickDamage.none: 'elementStone017.png',
      BrickDamage.some: 'elementStone027.png',
      BrickDamage.lots: 'elementStone049.png',
    },
    (BrickType.wood, BrickSize.size70x140) => {
      BrickDamage.none: 'elementWood016.png',
      BrickDamage.some: 'elementWood021.png',
      BrickDamage.lots: 'elementWood048.png',
    },

    (BrickType.explosive, BrickSize.size140x140)=>{
      BrickDamage.none: 'elementExplosive011.png',
      BrickDamage.some: 'elementExplosive014.png',
      BrickDamage.lots: 'elementExplosive049.png',
    },
    (BrickType.glass, BrickSize.size140x140)=> {
      BrickDamage.none: 'elementGlass011.png', 
      BrickDamage.some: 'elementGlass012.png',
      BrickDamage.lots: 'elementGlass046.png',
    },
    (BrickType.metal, BrickSize.size140x140) => {
      BrickDamage.none: 'elementMetal011.png',
      BrickDamage.some: 'elementMetal014.png',
      BrickDamage.lots: 'elementMetal049.png',
    },
    (BrickType.stone, BrickSize.size140x140) => {
      BrickDamage.none: 'elementStone011.png',
      BrickDamage.some: 'elementStone014.png',
      BrickDamage.lots: 'elementStone046.png',
    },
    (BrickType.wood, BrickSize.size140x140) => {
      BrickDamage.none: 'elementWood018.png',
      BrickDamage.some: 'elementWood013.png',
      BrickDamage.lots: 'elementWood045.png',
    },

    (BrickType.explosive, BrickSize.size220x140)=>{
      BrickDamage.none: 'elementExplosive011.png',
      BrickDamage.some: 'elementExplosive014.png',
      BrickDamage.lots: 'elementExplosive049.png',
    },
    (BrickType.glass, BrickSize.size220x140)=> {
      BrickDamage.none: 'elementGlass011.png', 
      BrickDamage.some: 'elementGlass012.png',
      BrickDamage.lots: 'elementGlass046.png',
    },
    (BrickType.metal, BrickSize.size220x140) => {
      BrickDamage.none: 'elementMetal011.png',
      BrickDamage.some: 'elementMetal014.png',
      BrickDamage.lots: 'elementMetal049.png',
    },
    (BrickType.stone, BrickSize.size220x140) => {
      BrickDamage.none: 'elementStone011.png',
      BrickDamage.some: 'elementStone014.png',
      BrickDamage.lots: 'elementStone046.png',
    },
    (BrickType.wood, BrickSize.size220x140) => {
      BrickDamage.none: 'elementWood018.png',
      BrickDamage.some: 'elementWood013.png',
      BrickDamage.lots: 'elementWood045.png',
    },

    (BrickType.explosive, BrickSize.size70x220)=>{
      BrickDamage.none: 'elementExplosive011.png',
      BrickDamage.some: 'elementExplosive014.png',
      BrickDamage.lots: 'elementExplosive049.png',
    },
    (BrickType.glass, BrickSize.size70x220)=> {
      BrickDamage.none: 'elementGlass011.png', 
      BrickDamage.some: 'elementGlass012.png',
      BrickDamage.lots: 'elementGlass046.png',
    },
    (BrickType.metal, BrickSize.size70x220) => {
      BrickDamage.none: 'elementMetal011.png',
      BrickDamage.some: 'elementMetal014.png',
      BrickDamage.lots: 'elementMetal049.png',
    },
    (BrickType.stone, BrickSize.size70x220) => {
      BrickDamage.none: 'elementStone011.png',
      BrickDamage.some: 'elementStone014.png',
      BrickDamage.lots: 'elementStone046.png',
    },
    (BrickType.wood, BrickSize.size70x220) => {
      BrickDamage.none: 'elementWood018.png',
      BrickDamage.some: 'elementWood013.png',
      BrickDamage.lots: 'elementWood045.png',
    },

    (BrickType.explosive, BrickSize.size140x220)=>{
      BrickDamage.none: 'elementExplosive011.png',
      BrickDamage.some: 'elementExplosive014.png',
      BrickDamage.lots: 'elementExplosive049.png',
    },
    (BrickType.glass, BrickSize.size140x220)=> {
      BrickDamage.none: 'elementGlass011.png', 
      BrickDamage.some: 'elementGlass012.png',
      BrickDamage.lots: 'elementGlass046.png',
    },
    (BrickType.metal, BrickSize.size140x220) => {
      BrickDamage.none: 'elementMetal011.png',
      BrickDamage.some: 'elementMetal014.png',
      BrickDamage.lots: 'elementMetal049.png',
    },
    (BrickType.stone, BrickSize.size140x220) => {
      BrickDamage.none: 'elementStone011.png',
      BrickDamage.some: 'elementStone014.png',
      BrickDamage.lots: 'elementStone046.png',
    },
    (BrickType.wood, BrickSize.size140x220) => {
      BrickDamage.none: 'elementWood018.png',
      BrickDamage.some: 'elementWood013.png',
      BrickDamage.lots: 'elementWood045.png',
    },
  };
}

class Brick extends BodyComponentWithUserData{
  Brick({
    required this.type,
    required this.size, 
    required BrickDamage damage,
    required Vector2 position,
    required Map<BrickDamage, Sprite> sprites,
  }) : _damage = damage,
       _sprites = sprites,
       super( 
        renderBody: false,
        bodyDef: BodyDef()
                  ..position = position
                  ..type = BodyType.dynamic,
        fixtureDefs: [
          FixtureDef(
            PolygonShape()
              ..setAsBoxXY(
                size.size.width/20 * brickScale,
                size.size.height/20 * brickScale,
              ),
          )
            ..restitution = 0.4
            ..density = type.density
            ..friction = type.friction
        ]);

  late final SpriteComponent _spriteComponent;
  
  final BrickType type;
  final BrickSize size;
  final Map<BrickDamage, Sprite> _sprites;

  BrickDamage _damage;
  BrickDamage get damage => _damage;
  set damage(BrickDamage value){
    _damage = value;
    _spriteComponent.sprite = _sprites[value];
  }


  @override
  Future<void> onLoad() {
    _spriteComponent = SpriteComponent(
      anchor: Anchor.center,
      scale: Vector2.all(1),
      sprite: _sprites[_damage],
      size: size.size.toVector2() / 10 * brickScale,
      position: Vector2(0, 0),
    );
    add(_spriteComponent);
    return super.onLoad();
  }
}