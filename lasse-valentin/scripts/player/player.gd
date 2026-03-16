extends CharacterBody2D

@export var speed_tiles := 3.0
@export var gravity_tiles := 15.0
@export var jump_height_tiles := 2.5
@export var height_tiles := 0.8

var speed: float
var gravity: float
var jump_force: float
var screen_size

func _ready() -> void:
	speed = Units.to_px(speed_tiles)
	gravity = Units.to_px(gravity_tiles)
	jump_force = Units.jump_force(jump_height_tiles, gravity_tiles)
	screen_size = get_viewport_rect().size
	_resize_collision()

func _resize_collision() -> void:
	var shape := $CollisionShape2D.shape as CapsuleShape2D
	shape = shape.duplicate()
	$CollisionShape2D.shape = shape
	var h := Units.to_px(height_tiles)
	shape.height = h
	shape.radius = h / 4.0
