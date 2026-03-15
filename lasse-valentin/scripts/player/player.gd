extends CharacterBody2D

@export var speed = 400
@export var gravity = 1400
var screen_size

func _ready() -> void:
	self.screen_size = get_viewport_rect().size

func _physics_process(_delta: float) -> void:
	pass
