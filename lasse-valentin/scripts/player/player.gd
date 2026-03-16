extends CharacterBody2D

@export var speed = 400
@export var gravity = 1400
@export var jump_force = 600
var screen_size

func _ready() -> void:
	self.screen_size = get_viewport_rect().size
