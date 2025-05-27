extends Area2D

@onready var sprite: Node2D = $sprites


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animate_portal()


func animate_portal():
	var offset := 1.0
	var duration := 2.0
	var start_pos := sprite.position
	var up_pos := start_pos + Vector2(0, -offset)
	var down_pos := start_pos + Vector2(0, offset)

	var tween := create_tween().set_loops()
	tween.tween_property(sprite, "position", up_pos, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(sprite, "position", down_pos, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _on_body_entered(body: Player) -> void:
	body.reset_player()
