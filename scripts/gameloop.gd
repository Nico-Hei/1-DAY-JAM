extends Node2D

var HeatBarScene = preload("res://scenes/HeatBar.tscn")
var BlockScene = preload("res://scenes/Block.tscn")

var heatbar
var block

var level = 0
var levelCounter = 0

@onready var hp = $"../UI/HP"

var HitOverflow = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Gameloop: initialized")
	
	spawnBlock()
	
	hp.zerohp.connect(_on_zerohp)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_hit() -> void:
	HitOverflow = true
	block.hitBlock()
	if block.hits == 5:
		block.call_deferred("queue_free")  # only delete when all signals/functions are completed
		heatbar.call_deferred("queue_free")  # only delete when all signals/functions are completed
		levelCounter += 1
		if levelCounter == 2:
			levelCounter = 0
			level += 1
		$Timer.start()

func _on_overflow() -> void:
	if !HitOverflow:
		hp.reduceHP()
	else:
		HitOverflow = false

func _on_zerohp() -> void:
	call_deferred("queue_free")
	# Youve lost display, try again

func spawnBlock() -> void:
	HitOverflow = false
	heatbar = HeatBarScene.instantiate()
	block = BlockScene.instantiate()
	
	add_child(block)
	add_child(heatbar)
	
	block.level = level
	heatbar.setLevel(level)
	
	heatbar.hit.connect(_on_hit)
	heatbar.overflow.connect(_on_overflow)


func _on_timer_timeout() -> void:
	spawnBlock()
	$Timer.stop()
