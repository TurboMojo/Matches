extends Node2D

@export var SPEED = 300
var can_shoot = true
var velocity = 0.0
@export var bullet_scene : PackedScene
var id : int
@onready var game = get_node("/root/Game/GameManager")


func _physics_process(_delta: float) -> void:
	if !is_multiplayer_authority():
		return
	look_at(get_global_mouse_position())	

func _input(event):
	if event.is_action_pressed("shoot") and is_multiplayer_authority() and game.isCardSelection == false:
		spawn_bullet.rpc(multiplayer.get_unique_id(), SPEED)

@rpc("call_local")
func spawn_bullet(shooter_id: int, speed: float) -> void:	
	var origin = global_position
	var direction = global_rotation
	var bullet = bullet_scene.instantiate()	
	bullet.speed = speed
	bullet.name = "Bullet" + str(game.bullets_fired)
	game._players_spawn_node.add_child(bullet, true)
	bullet.transform = global_transform
