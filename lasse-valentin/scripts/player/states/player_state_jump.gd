extends PlayerStateBase

func enter():
	actor.velocity.y = -actor.jump_force
	animated_sprite.animation = "up"
	animated_sprite.play()

func physics_update(delta):
	apply_gravity(delta)

	# Allow air control
	var direction := get_horizontal_input()
	actor.velocity.x = direction * actor.speed

	if direction != 0.0:
		animated_sprite.flip_h = actor.velocity.x < 0

	actor.move_and_slide()

	if actor.is_on_floor():
		if direction != 0.0:
			state_machine.change_state(state_machine.get_node("Move"))
		else:
			state_machine.change_state(state_machine.get_node("Idle"))
