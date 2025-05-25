extends Control
class_name GUI
@onready var gui_animations: AnimationPlayer = $GUIanimations
@onready var bg: CanvasLayer = $"../../BG"
@onready var status: HBoxContainer = %status
@onready var play: Button = %play
@export var main:Main

@onready var transition: ColorRect = $"transition layer/transition"
@onready var info: CanvasLayer = $info


@onready var spinsfx: SpinBox = $PanelContainer/HBoxContainer/settingsContainer/Spinsfx
@onready var spinmusic: SpinBox = %Spinmusic




var is_in_ui:bool = true
var is_in_settings:bool = false

func _ready() -> void:
	Global.gui = self
	set_audio()
	
	#gui_animations.play("showGUI")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_play_pressed() -> void:
	if is_in_settings:
		gui_animations.play_backwards("ShowSettings")
		await gui_animations.animation_finished
	gui_animations.play_backwards("showGUI")
	await gui_animations.animation_finished
	is_in_ui = false
	if Global.data.first_run:
		info.start(0,true)
		return
	load_game()
func load_game():
	await set_transition(true)
	main.load_world(0)
	main.spawn_player()
	bg.hide()
	play.hide()
	await set_transition(false)

func _on_settings_pressed() -> void:
	if is_in_settings:
		gui_animations.play_backwards("ShowSettings")
	else:
		gui_animations.play("ShowSettings")
	is_in_settings = !is_in_settings

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if gui_animations.is_playing():
			return
		if is_in_settings:
			gui_animations.play_backwards("ShowSettings")
			is_in_settings = false
			await gui_animations.animation_finished
		if is_in_ui:
			gui_animations.play_backwards("showGUI")
			await gui_animations.animation_finished
		else:
			gui_animations.play("showGUI")
			get_tree().paused = !is_in_ui
			await gui_animations.animation_finished
		
		
		is_in_ui = !is_in_ui
		get_tree().paused = is_in_ui

func rotate_item(index,angle: float, duration: float = 0.5):
	var item = status.get_children()[index]
	item.rotate_item(angle,duration)
	
func change_texture(index:int,terxture_index:int):
	var item = status.get_children()[index] as CustomTR
	item.change_texture(terxture_index)

func set_dafault_status():
	rotate_item(1,0)
	change_texture(0,0)

func _on_quit_pressed() -> void:
	if Global.in_game:
		Global.in_game = false
		await set_transition(true)
		Global.main.dispawn()
		bg.show()
		play.show()
		set_dafault_status()
		await set_transition(false)
	else:
		get_tree().quit()

var transition_tween
func set_transition(start:bool = true,color:Color = Color.BLACK) -> bool:
	if transition_tween:
		transition_tween.kill()
	transition_tween = create_tween()
	if start:
		transition.visible = true
		transition_tween.tween_property(transition,"color",color,1)
		await transition_tween.finished
	else:
		transition_tween.tween_property(transition,"color",Color("#00000000"),1)
		await transition_tween.finished
		transition.visible = false
	return true
		

func _on_spinsfx_value_changed(value: float) -> void:
	Global.data.sfx = value/100
	Global.data.save()
	set_audio()


func _on_spinmusic_value_changed(value: float) -> void:
	Global.data.music = value/100
	Global.data.save()
	set_audio()

func set_audio(data:Data = Global.data):
	var bus_index = AudioServer.get_bus_index("sfx")
	var bus_index1 = AudioServer.get_bus_index("music")
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(data.sfx)
	)
	AudioServer.set_bus_volume_db(
		bus_index1,
		linear_to_db(data.music)
	)
	spinsfx.value = data.sfx *100
	spinmusic.value = data.music *100
	
