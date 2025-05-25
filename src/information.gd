extends CanvasLayer

@export var gui:GUI

@export var pages:Array[Control]
@onready var total_pages = len(pages) 
var current_page:int = 0
var loadgame:bool = false

func start(page:int = 0,on_play:bool = false):
	loadgame = on_play
	await gui.set_transition()
	visible = true
	pages[page].visible = true
	await gui.set_transition(false)

func next():
	await gui.set_transition()
	if current_page == len(pages) -1:
		visible = false
		current_page = 0
		pages[current_page+1].visible = false
		Global.data.first_run = false
		Global.data.save()
		if loadgame:
			gui.load_game()
			return
		await gui.set_transition(false)
		return
	pages[current_page].visible = false
	current_page += 1
	pages[current_page].visible = true
	await gui.set_transition(false)
	return

func  _input(event: InputEvent) -> void:
	if Input.is_anything_pressed():
		if visible:
			await  next()
