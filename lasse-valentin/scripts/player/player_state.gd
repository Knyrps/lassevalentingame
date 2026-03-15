extends Node
class_name PlayerState

var actor: CharacterBody2D

func enter():
	pass
	
func exit():
	pass
	
func update(delta):
	pass

func physics_update(delta):
	actor.velocity.x = 0
	
	if actor.is_on_floor():
		actor.velocity.y = 0
	else:
		actor.velocity.y += actor.gravity * delta
	
	if Input.is_action_pressed("move_left"):
		actor.velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		actor.velocity.x += 1

	# Animation logic
	if actor.velocity.x != 0:
		actor.velocity.x *= actor.speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	if actor.velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = actor.velocity.x < 0

	actor.move_and_slide()
