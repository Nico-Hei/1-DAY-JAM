extends Control

var possiblePositions = [Vector2i(0,0), Vector2i(1,0), Vector2i(2,0), Vector2i(3,0), Vector2i(4,0), Vector2i(5,0)]
@onready var zone: TileMapLayer = $Zone

var randomPosition

var indicatorPosition = 0
@onready var indicator: TileMapLayer = $Indicator

var inputLocked = false
@onready var cooldown: Timer = $Indicator/Cooldown
@onready var cooldown_notification: Sprite2D = $Cooldown

@onready var speed: Timer = $Indicator/Timer

signal hit
signal overflow # Triggered when indicator surpaces input field

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Gameloop:heatbar: initialized")
	randomPosition = possiblePositions.pick_random()
	zone.set_cell(randomPosition, 0, Vector2i(3,0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Space") && !inputLocked:
		if  randomPosition == possiblePositions[indicatorPosition-1]:
			$AudioStreamPlayer2D.play()
			resetZone()
			emit_signal("hit")
		else:
			inputLocked = true
			cooldown_notification.visible = true
			$AudioStreamPlayer2D2.play()
			cooldown.start()

func _on_timer_timeout() -> void:
	indicator.erase_cell(possiblePositions[indicatorPosition-1])
	indicator.set_cell(possiblePositions[indicatorPosition], 0, Vector2i(2,0))
	
	indicatorPosition += 1
	if indicatorPosition == 6:
		indicatorPosition = 0
		emit_signal("overflow")

func _on_cooldown_timeout() -> void:
	inputLocked = false
	cooldown_notification.visible = false
	cooldown.stop()

func setLevel(level: int) -> void:
	if level == 1:
		speed.wait_time = 0.3
	elif level == 2:
		speed.wait_time = 0.1
	elif level == 3: 
		speed.wait_time = 0.1

func resetZone() -> void:
	zone.erase_cell(randomPosition)
	randomPosition = possiblePositions.pick_random()
	zone.set_cell(randomPosition, 0, Vector2i(3,0))
