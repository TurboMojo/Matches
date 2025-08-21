extends Node2D

@export var SPEED = 300
var can_shoot = true
var velocity = 0.0
@export var bullet_scene : PackedScene
var id : int

func _process(delta: float) -> void:
	if Globals.is_network_authority():
		update_gun()

	
func _input(event: InputEvent) -> void:
	if Globals.is_network_authority() and event is InputEventMouseMotion:
		rpc("sync_gun_position", get_global_mouse_position())

func update_gun():
	var mouse_position = get_global_mouse_position()
	look_at(mouse_position)
	
	# Flip the gun sprite based on mouse position
	if mouse_position.x < global_position.x:
		$GunSprite.flip_h = true
	else:
		$GunSprite.flip_h = false

# RPC function to synchronize gun state
@rpc
func sync_gun_position(mouse_position: Vector2):
	look_at(mouse_position)
