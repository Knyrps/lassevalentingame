extends PlayerStateBase

func enter():
	animated_sprite.stop()

func physics_update(delta):
	apply_gravity(delta)
	actor.velocity.x = 0
	actor.move_and_slide()

	var direction := get_horizontal_input()
	if direction != 0.0:
		state_machine.change_state(state_machine.get_node("Move"))
		return

	if Input.is_action_just_pressed("jump") and actor.is_on_floor():
		state_machine.change_state(state_machine.get_node("Jump"))
		return
