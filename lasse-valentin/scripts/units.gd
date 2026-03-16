class_name Units

const TILE := 64

## Converts a tile distance to pixels.
static func to_px(tiles: float) -> float:
	return tiles * TILE

## Converts pixels to tile distance.
static func to_tiles(px: float) -> float:
	return px / TILE

## Calculates the initial velocity needed to reach [param height] tiles given [param gravity] in tiles/s².
static func jump_force(height: float, grav: float) -> float:
	return sqrt(2.0 * to_px(grav) * to_px(height))
