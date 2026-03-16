extends Node2D

const TILE_SIZE := Units.TILE
const WORLD_WIDTH := 15
const WORLD_DEPTH := 60
const TERRAIN_START := 2

@export var block_types: Array[BlockType] = []
@export var background_block: BlockType

@onready var terrain_layer: TileMapLayer = $TerrainLayer
@onready var background_layer: TileMapLayer = $BackgroundLayer

var source_id: int = 0
var bg_source_id: int = 0
var _tile_coords: Dictionary = {}

## Returns the tile atlas coords for a block type by id.
func get_tile(block_id: String) -> Vector2i:
	return _tile_coords[block_id]

func _ready() -> void:
	var tileset := _create_tileset(true)
	source_id = tileset.get_source_id(0)
	var bg_tileset := _create_tileset(false)
	bg_source_id = bg_tileset.get_source_id(0)
	terrain_layer.tile_set = tileset
	terrain_layer.collision_enabled = true
	background_layer.tile_set = bg_tileset
	background_layer.collision_enabled = false
	generate_world()
	terrain_layer.update_internals()

## Builds a TileSet from block_types with optional physics collision.
func _create_tileset(with_physics: bool) -> TileSet:
	var all_blocks := block_types.duplicate()
	if background_block:
		all_blocks.append(background_block)

	var ts := TileSet.new()
	ts.tile_size = Vector2i(TILE_SIZE, TILE_SIZE)
	if with_physics:
		ts.add_physics_layer()
		ts.set_physics_layer_collision_layer(0, 1)
		ts.set_physics_layer_collision_mask(0, 1)

	ts.add_custom_data_layer()
	ts.set_custom_data_layer_name(0, "block_type")
	ts.set_custom_data_layer_type(0, TYPE_STRING)
	ts.add_custom_data_layer()
	ts.set_custom_data_layer_name(1, "hardness")
	ts.set_custom_data_layer_type(1, TYPE_INT)
	ts.add_custom_data_layer()
	ts.set_custom_data_layer_name(2, "minable")
	ts.set_custom_data_layer_type(2, TYPE_BOOL)

	var count := all_blocks.size()
	var img := Image.create(TILE_SIZE * count, TILE_SIZE, false, Image.FORMAT_RGBA8)
	for i in count:
		_fill_block(img, i, all_blocks[i].color)

	var tex := ImageTexture.create_from_image(img)
	var source := TileSetAtlasSource.new()
	source.texture = tex
	source.texture_region_size = Vector2i(TILE_SIZE, TILE_SIZE)

	var half := float(TILE_SIZE) / 2.0
	var coll_points := PackedVector2Array([
		Vector2(-half, -half), Vector2(half, -half),
		Vector2(half, half), Vector2(-half, half)
	])

	for i in count:
		var pos := Vector2i(i, 0)
		_tile_coords[all_blocks[i].id] = pos
		source.create_tile(pos)

	ts.add_source(source)

	for i in count:
		var block: BlockType = all_blocks[i]
		var pos := Vector2i(i, 0)
		var td := source.get_tile_data(pos, 0)
		td.set_custom_data("block_type", block.id)
		td.set_custom_data("hardness", block.hardness)
		td.set_custom_data("minable", block.minable)
		if with_physics and block.collides:
			td.add_collision_polygon(0)
			td.set_collision_polygon_points(0, 0, coll_points)

	return ts

## Draws a single tile block with a border into the atlas image.
func _fill_block(img: Image, index: int, color: Color) -> void:
	var x_start := index * TILE_SIZE
	img.fill_rect(Rect2i(x_start, 0, TILE_SIZE, TILE_SIZE), color)
	var border := color.darkened(0.3)
	img.fill_rect(Rect2i(x_start, 0, TILE_SIZE, 1), border)
	img.fill_rect(Rect2i(x_start, TILE_SIZE - 1, TILE_SIZE, 1), border)
	img.fill_rect(Rect2i(x_start, 0, 1, TILE_SIZE), border)
	img.fill_rect(Rect2i(x_start + TILE_SIZE - 1, 0, 1, TILE_SIZE), border)

## Procedurally fills the terrain with dirt, stone, ore, caves, and bedrock borders.
func generate_world() -> void:
	terrain_layer.clear()
	background_layer.clear()

	var t_bedrock := get_tile("bedrock")
	var t_dirt := get_tile("dirt")
	var t_stone := get_tile("stone")
	var t_ore := get_tile("ore")

	for y in range(TERRAIN_START):
		terrain_layer.set_cell(Vector2i(0, y), source_id, t_bedrock)
		terrain_layer.set_cell(Vector2i(WORLD_WIDTH - 1, y), source_id, t_bedrock)

	var entrance_center: int = WORLD_WIDTH / 2

	for x in range(WORLD_WIDTH):
		for y in range(WORLD_DEPTH):
			var cell := Vector2i(x, y + TERRAIN_START)
			var depth := y

			if x == 0 or x == WORLD_WIDTH - 1:
				terrain_layer.set_cell(cell, source_id, t_bedrock)
				continue

			if abs(x - entrance_center) <= 1 and depth < 3:
				continue

			if depth >= WORLD_DEPTH - 1:
				terrain_layer.set_cell(cell, source_id, t_bedrock)
				continue

			if depth > 5 and randf() < 0.03:
				continue

			var ore_chance := clampf(float(depth) / float(WORLD_DEPTH) * 0.15, 0.02, 0.12)
			if randf() < ore_chance:
				terrain_layer.set_cell(cell, source_id, t_ore)
				continue

			if depth < 20:
				terrain_layer.set_cell(cell, source_id, t_dirt)
			else:
				terrain_layer.set_cell(cell, source_id, t_stone)
