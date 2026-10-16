extends TileMapLayer

var hits = 0
var level = 0

func setBlock(level: int, state: int) -> void:
	set_cell(Vector2i(0,0), level, Vector2i(state, 0))
	level = level

func _ready() -> void:
	print("Gameloop:Block: initialized")

func _process(delta: float) -> void:
	setBlock(level, hits)

func hitBlock() -> void:
	hits += 1
