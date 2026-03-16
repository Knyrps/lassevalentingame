extends PlayerStateBase

func enter():
	animated_sprite.animation = "walk"
	animated_sprite.play()

func physics_update(delta):
	apply_gravity(delta)

	var direction := get_horizontal_input()
	actor.velocity.x = direction * actor.speed

	if direction == 0.0:
		state_machine.change_state(state_machine.get_node("Idle"))
		return

	if Input.is_action_just_pressed("jump") and actor.is_on_floor():
		state_machine.change_state(state_machine.get_node("Jump"))
		return

	animated_sprite.flip_h = actor.velocity.x < 0
	actor.move_and_slide()
