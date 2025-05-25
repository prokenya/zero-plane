extends Node
class_name  Main
@export var worlds:Array[PackedScene]
@onready var world:Node2D
@onready var Player:PackedScene = preload("res://src/player/player.tscn")
var current_player:Player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.main = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_world(index:int):
	get_tree().paused = true
	var instace = worlds[index].instantiate()
	if world:
		world.queue_free()
	world = instace
	add_child(world)
	get_tree().paused = false

func spawn_player(pos:Vector2 = Vector2.ZERO):
	if current_player:
		current_player.queue_free()
	current_player = Player.instantiate()
	current_player.position = pos
	add_child(current_player)

func dispawn():
	world.queue_free()
	current_player.queue_free()
