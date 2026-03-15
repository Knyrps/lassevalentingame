extends CharacterBody2D

@export var speed = 400
@export var gravity = 1400
var screen_size

func _ready() -> void:
	self.screen_size = get_viewport_rect().size

func _physics_process(_delta: float) -> void:
	self.velocity.x = 0
	
	if self.is_on_floor():
		self.velocity.y = 0
	else:
		self.velocity.y += self.gravity * _delta
	
	if Input.is_action_pressed("move_left"):
		self.velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		self.velocity.x += 1

	# Animation logic
	if self.velocity.x != 0:
		self.velocity.x *= self.speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	if self.velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = self.velocity.x < 0

	self.move_and_slide()
