@tool
extends Area2D

enum types 
{
	GRAVITY,
	REVERSE_G,
	REVERSE_P,
	DASH,
}
@onready var sprite: Sprite2D = $Sprite2D
@onready var point_light: PointLight2D = $Sprite2D/PointLight2D
@onready var timer: Timer = $Timer

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


@export var type = types.GRAVITY:
	get:
		return type
	set(value):
		type = value
		if sprite:
			sprite.frame = type
@export var lock_rotation:bool = (type != types.GRAVITY)

@export var streams:Array[AudioStream]

var rotation_tween
var light_tween

func _ready() -> void:
	sprite.position = Vector2.ZERO
	animate_cristal()
	sprite.frame = type
	if type in [types.REVERSE_G,types.REVERSE_P]:
		Global.connect("sync_types",sync_types)
	elif type == types.GRAVITY and !lock_rotation:
		Global.connect("sync_rotation",animate_rotation)
		

func sync_types(stype:int):
	type = stype
	animate_light()

func interact(player:Player) -> bool:
	if !timer.is_stopped(): return false
	
	match type:
		0: interact_gravity(player);play_sound(0)
		1: interact_reverse(player);play_sound(1)
		2: interact_reverse(player);play_sound(1)
		3: insteract_dash(player);play_sound(2)
		
	timer.start()
	return true

func interact_gravity(player:Player):
	var angle = rotation + deg_to_rad(90.0)
	var direction = Vector2(cos(angle), sin(angle)).normalized()
	player.default_gravity_direction = direction
	player.velocity = Vector2.ZERO
	if !lock_rotation:
		Global.emit_signal("sync_rotation",angle)
	Global.gui.rotate_item(1,angle - deg_to_rad(90.0),0.25)

func interact_reverse(player:Player):
	var next_type
	if type == types.REVERSE_G:
		next_type = types.REVERSE_P
		player.reverce_magnet = true
	else:
		next_type = types.REVERSE_G
		player.reverce_magnet = false
	Global.emit_signal("sync_types",next_type)
	Global.gui.change_texture(0,next_type-1)
	animate_light()

func insteract_dash(player:Player):
	var angle = rotation + deg_to_rad(90.0)
	var direction = Vector2(cos(angle), sin(angle)).normalized()
	player.velocity = direction * 700
	animate_light()

func animate_rotation(angle:float):
	if rotation_tween:
		rotation_tween.kill()
	rotation_tween = create_tween()
	
	rotation_tween.tween_property(self,"rotation",angle,1)
	animate_light()

func animate_light(duration:float = 1):
	if light_tween:
		light_tween.kill()
	light_tween = create_tween()
		
	light_tween.tween_property(point_light,"energy",1,duration/2)
	light_tween.tween_property(point_light,"energy",3,duration/2)

func animate_cristal():
	var offset := 3.0
	var duration := 1.5
	var start_pos := sprite.position
	var up_pos := start_pos + Vector2(0, -offset)
	var down_pos := start_pos + Vector2(0, offset)

	var tween := create_tween().set_loops()
	tween.tween_property(sprite, "position", up_pos, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(sprite, "position", down_pos, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func play_sound(id:int):
	audio_stream_player.stream = streams[id]
	audio_stream_player.play()
