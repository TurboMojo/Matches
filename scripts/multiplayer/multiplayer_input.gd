class_name PlayerInput extends BaseNetInput

@export var switch_time: float = 1.0

var input_direction = Vector2.ZERO
var input_jump = 0
var is_firing = false
#var aim_direction
var aim: Vector2 = Vector2.ZERO
var movement: Vector2 = Vector2.ZERO
var _last_mouse_input: float = 0.0
var _aim_target: Vector2
var _projected_target: Vector2
var _has_aim: bool = false
@onready var _player: Node2D = get_parent()
var camera: Camera2D

func _input(event):
	if event is InputEventMouse:
		_last_mouse_input = NetworkTime.local_time

func _gather():
		
	input_direction = Input.get_axis("move_left", "move_right")
	aim = get_viewport().get_mouse_position()
	#aim.normalized()
	print("aim.x: ", aim.x," aim.y: ",aim.y)

func _physics_process(delta: float) -> void:
	
	if camera == null:
		camera = get_node("../Camera2D")

func _process(delta):
	input_jump = Input.get_action_strength("jump")
	is_firing = Input.is_action_pressed("shoot")
