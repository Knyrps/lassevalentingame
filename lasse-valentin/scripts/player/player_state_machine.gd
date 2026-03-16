extends Node

var current_state: PlayerStateBase
var _cached_actor: CharacterBody2D
var _cached_animated_sprite: AnimatedSprite2D

func _ready() -> void:
	_cached_actor = self.get_parent() as CharacterBody2D
	_cached_animated_sprite = _cached_actor.get_node("AnimatedSprite2D") as AnimatedSprite2D
	change_state($Idle)

func change_state(new_state: PlayerStateBase):
	if current_state:
		current_state.exit()

	current_state = new_state
	current_state.actor = _cached_actor
	current_state.animated_sprite = _cached_animated_sprite
	current_state.state_machine = self
	current_state.enter()

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)
