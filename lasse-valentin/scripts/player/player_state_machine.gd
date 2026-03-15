extends Node

var current_state: PlayerState

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	actor.get_parent()
	change_state($Idle)

func change_state(new_state: PlayerState):
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)
		
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)
