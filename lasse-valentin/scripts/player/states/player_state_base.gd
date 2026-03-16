extends Node
class_name PlayerStateBase

var actor: CharacterBody2D
var animated_sprite: AnimatedSprite2D
var state_machine

func enter():
	pass

func exit():
	pass

func update(_delta):
	pass

func physics_update(_delta):
	pass

func apply_gravity(delta):
	if actor.is_on_floor():
		actor.velocity.y = 0
	else:
		actor.velocity.y += actor.gravity * delta

func get_horizontal_input() -> float:
	var direction := 0.0
	if Input.is_action_pressed("move_left"):
		direction -= 1.0
	if Input.is_action_pressed("move_right"):
		direction += 1.0
	return direction
