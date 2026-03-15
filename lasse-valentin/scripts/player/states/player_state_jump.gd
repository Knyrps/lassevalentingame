extends PlayerStateBase

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
	
	if Input.is_action_pressed("jump"):
		actor.velocity.x -= 1

	# Animation logic
	if actor.velocity.x != 0:
		actor.velocity.x *= actor.speed
		animated_sprite.play()
	else:
		animated_sprite.stop()
	if actor.velocity.x != 0:
		animated_sprite.animation = "up"
		animated_sprite.flip_v = false
		animated_sprite.flip_h = actor.velocity.x < 0

	actor.move_and_slide()
