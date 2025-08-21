extends Area2D

var speed = 250
@export var damage = 25
@export var pid : int

func _enter_tree() -> void:
	set_multiplayer_authority(pid)

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_body_entered(body):
	
	if !is_multiplayer_authority():
		return
	
	if body is PlatformerController2D:
		body.take_damage.rpc_id(1, damage)
	
	remove_bullet()


func remove_bullet():
	queue_free()
