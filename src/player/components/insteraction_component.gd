extends Area2D

@onready var player:CharacterBody2D = get_parent()
@onready var interaction:Area2D = null
var inter_pressed:bool = false

func _on_area_entered(inter: Area2D) -> void:
	interaction = inter
	handle_interaction()

func _on_area_exited(inter: Area2D) -> void:
	interaction = null

func _input(event: InputEvent) -> void:
	if player.on_something: return
	if Input.is_action_just_pressed("ui_accept"):
		inter_pressed = true
	if Input.is_action_just_released("ui_accept"):
		inter_pressed = false
	
	handle_interaction()


func handle_interaction():
	if !interaction: return
	if inter_pressed:
		var status = interaction.interact(player)
		inter_pressed = !status
