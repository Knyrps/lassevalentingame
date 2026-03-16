extends Node

@export var terrain_path: NodePath
@export var background_path: NodePath
@export var player_path: NodePath

var terrain_layer: TileMapLayer
var background_layer: TileMapLayer
var player: CharacterBody2D

var _block_health: Dictionary = {}
var _mine_timer := 0.0
var _current_target := Vector2i(-9999, -9999)

const MINE_INTERVAL := 0.25

func _ready() -> void:
	terrain_layer = get_node(terrain_path)
	background_layer = get_node(background_path)
	player = get_node(player_path)

func _process(delta: float) -> void:
	if not Input.is_action_pressed("mine"):
		_mine_timer = 0.0
		_current_target = Vector2i(-9999, -9999)
		return

	var target := _get_target_cell()
	if target != _current_target:
		_current_target = target
		_mine_timer = MINE_INTERVAL

	_mine_timer += delta
	if _mine_timer >= MINE_INTERVAL:
		_mine_timer -= MINE_INTERVAL
		_try_mine(target)

## Returns the tile cell adjacent to the player in the aimed direction.
func _get_target_cell() -> Vector2i:
	var dir := Vector2.DOWN
	if Input.is_action_pressed("move_left"):
		dir = Vector2.LEFT
	elif Input.is_action_pressed("move_right"):
		dir = Vector2.RIGHT
	elif Input.is_action_pressed("move_down"):
		dir = Vector2.DOWN

	var player_cell := terrain_layer.local_to_map(
		terrain_layer.to_local(player.global_position)
	)
	return player_cell + Vector2i(int(dir.x), int(dir.y))

## Deals one hit to the block at the given cell, destroying it when health reaches zero.
func _try_mine(cell: Vector2i) -> void:
	var tile_data := terrain_layer.get_cell_tile_data(cell)
	if tile_data == null:
		return

	var is_minable: bool = tile_data.get_custom_data("minable")
	if not is_minable:
		return

	var max_hardness: int = tile_data.get_custom_data("hardness")
	if not _block_health.has(cell):
		_block_health[cell] = max_hardness

	_block_health[cell] -= 1
	if _block_health[cell] <= 0:
		_destroy_block(cell)

## Removes the terrain tile and places a background tile in its place.
func _destroy_block(cell: Vector2i) -> void:
	var world = terrain_layer.get_parent()
	terrain_layer.erase_cell(cell)
	_block_health.erase(cell)
	background_layer.set_cell(cell, world.bg_source_id, world.get_tile("background"))
