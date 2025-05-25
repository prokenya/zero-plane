extends Node

var in_game:bool = false

@onready var main:Main
@onready var gui:Control
@onready var data = Data.load_or_create()

signal sync_types(type:int)

signal sync_rotation(angle:float)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
