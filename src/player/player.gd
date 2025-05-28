extends CharacterBody2D
class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -200.0
const AXELERATION = 15

var reverce_magnet:bool = false:
	set(value):
		reverce_magnet = value
		set_shader_param(3 if value else 0)
		if value:
			is_on_magnet = magnet_state[1]
		else:
			is_on_magnet = magnet_state[0]
@export var is_on_magnet: bool = false
var old_is_on_magnet:bool = is_on_magnet
	
@export var on_something = false:
	set(value):
		on_something = value
		if sprite:
			if is_on_magnet:
				sprite.frame = 1
			else:
				sprite.frame = 0
			

@onready var sprite: Sprite2D = $Sprite2D
var default_gravity_direction = Vector2.DOWN

@onready var magnetized_player: AudioStreamPlayer = $magnetized_player
@onready var demagnetized_player: AudioStreamPlayer = $demagnetized_player
@onready var hurt_player: AudioStreamPlayer = $hurt_player
@onready var insteraction: Area2D = $insteraction


func _ready() -> void:
	Global.in_game = true
	set_shader_param(0)

func _physics_process(delta: float) -> void:
	
	var gravity_direction = get_gravity_direction()
	on_something = is_on_wall() or is_on_floor() or is_on_ceiling()
	up_direction = -gravity_direction
	#print("f> "+str(is_on_floor()) + " w> "+str(is_on_wall()) + " c> "+str(is_on_ceiling()))
	#if not is_on_magnet or not on_something:
		#velocity += 980 * gravity_direction * delta;
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") && is_on_floor():
		velocity += JUMP_VELOCITY * gravity_direction
		
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("ui_left", "ui_right","ui_up","ui_down")
	var player_direction = Vector2(gravity_direction.y,-gravity_direction.x)
	#print(gravity_direction)
	#print(player_direction)
	if direction:
		var addvelocity = direction.project(player_direction).normalized() * AXELERATION
		if direction.y != 0:
			velocity.y = clamp(velocity.y + addvelocity.y,-SPEED,SPEED)
		if direction.x != 0:
			velocity.x = clamp(velocity.x + addvelocity.x,-SPEED,SPEED)
			
	elif is_on_floor() and !Input.is_action_just_pressed("ui_accept") and !direction:
			velocity = lerp(velocity,Vector2.ZERO,0.9)

	if not is_on_magnet or not on_something:
		velocity += 980 * gravity_direction * delta;
	

	$debug/graviti.rotation = gravity_direction.angle()
	$debug/direction.rotation = player_direction.angle()
	sprite.rotation = gravity_direction.angle() - deg_to_rad(180.0)
	move_and_slide()

var cached_gravity_direction: Vector2 = Vector2.DOWN

func get_gravity_direction() -> Vector2:
	if not is_on_magnet:
		cached_gravity_direction = default_gravity_direction
		return cached_gravity_direction

	var wall_vec := Vector2.ZERO
	var floor_vec := Vector2.ZERO

	if is_on_ceiling():
		floor_vec = -default_gravity_direction
	elif is_on_floor():
		floor_vec = -get_floor_normal()

	if is_on_wall():
		wall_vec = -get_wall_normal()
	var gravity_vec := wall_vec + floor_vec
	
	if gravity_vec != Vector2.ZERO:
		#print("asdsad")/'////'
		cached_gravity_direction = gravity_vec.normalized()
		return cached_gravity_direction
	else:
		return cached_gravity_direction

func reset_player():
	cached_gravity_direction = Vector2.DOWN
	default_gravity_direction = Vector2.DOWN
	reverce_magnet = false
	insteraction.inter_pressed = false
	Global.emit_signal("sync_types",1)
	Global.emit_signal("sync_rotation",0)
	Global.gui.set_dafault_status()
#region magnet
func _on_magnet_area_body_entered(body: Node2D) -> void:
	update_magnet_state(true)
		
func _on_magnet_area_body_exited(body: Node2D) -> void:
	update_magnet_state(false)

func _on_no_magnet_area_body_entered(body: Node2D) -> void:
	update_magnet_state(null,true)
	

func _on_no_magnet_area_body_exited(body: Node2D) -> void:
	update_magnet_state(null,false)
	

var magnet_state:Array[bool] = [false,false]
func update_magnet_state(is_in_magnet_area,is_in_no_magnet_area = null) -> void: 
	if is_in_magnet_area == null:
		is_in_magnet_area = magnet_state[0]
	if is_in_no_magnet_area == null:
		is_in_no_magnet_area = magnet_state[1]
		
	if reverce_magnet:
		is_on_magnet = is_in_no_magnet_area
	else:
		is_on_magnet = is_in_magnet_area
	magnet_state[0] = is_in_magnet_area
	magnet_state[1] = is_in_no_magnet_area
	if is_on_magnet and old_is_on_magnet != is_on_magnet:
		magnetized_player.play()
	elif old_is_on_magnet != is_on_magnet:
		demagnetized_player.play()
	old_is_on_magnet = is_on_magnet
#endregion


func set_shader_param(to:int = 1):
	var shader_mat := sprite.material as ShaderMaterial
	shader_mat.set_shader_parameter("factor", to)

func _on_hurbox_body_entered(body: Node2D) -> void:
	velocity = Vector2.ZERO
	position = Vector2.ZERO
	hurt_player.play()
	reset_player()
