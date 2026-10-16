extends Node2D

var HeatBarScene = preload("res://scenes/HeatBar.tscn")
var BlockScene = preload("res://scenes/Block.tscn")

var heatbar
var block

@onready var hp = $"../UI/HP"

var HitOverflow = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Gameloop: initialized")
	
	heatbar = HeatBarScene.instantiate()
	block = BlockScene.instantiate()
	
	add_child(block)
	add_child(heatbar)
	
	heatbar.hit.connect(_on_hit)
	heatbar.overflow.connect(_on_overflow)
	hp.zerohp.connect(_on_zerohp)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_hit() -> void:
	HitOverflow = true
	block.hitBlock()
	if block.hits == 5:
		heatbar.hit.disconnect(_on_hit)
		block.call_deferred("queue_free")  # only delete when all signals/functions are completed
		heatbar.call_deferred("queue_free")

func _on_overflow() -> void:
	if !HitOverflow:
		hp.reduceHP()

func _on_zerohp() -> void:
	call_deferred("queue_free")
	# Youve lost display, try again
