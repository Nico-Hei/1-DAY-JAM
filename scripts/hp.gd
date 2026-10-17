extends TileMapLayer

var hp = 10

signal zerohp

func reduceHP() -> void:
	hp -= 1
	set_cell(Vector2i(0,0), 0, Vector2i(10-hp,0))

func expandHP() -> void:
	hp += 1
	set_cell(Vector2i(0,0), 0, Vector2i(10-hp,0))
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("UI:heatbar: initialized")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hp == 0:
		emit_signal("zerohp")
