extends TextureRect
class_name CustomTR
@export var texure_list:Array[Texture2D]

var tween

func _ready():
	await get_tree().process_frame
	pivot_offset = size / 2

func rotate_item(angle: float, duration: float) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "rotation", angle, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func change_texture(terxture_index:int):
	texture = texure_list[terxture_index]
