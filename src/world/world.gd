extends Node2D

var tween
func _on_area_2d_body_entered(body: Node2D) -> void:
	var player = Global.main.current_player
	Global.gui.bg_end.visible = true
	tween = create_tween()
	tween.tween_property(player,"rotation",90,20)
	tween.parallel().tween_property(Global.gui.bg_end.get_children()[0],"modulate",Color("#ffffff"),10)
	await tween.finished
	Global.gui.bg_end.visible = false
	Global.gui._on_quit_pressed()
