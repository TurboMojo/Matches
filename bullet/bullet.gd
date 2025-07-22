extends Area2D

var speed = 250
@export var damage = 25

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_body_entered(body):
	
	if !is_multiplayer_authority():
		return
	
	if body is PlatformerController2D:
		body.game.take_damage.rpc_id(1, body.player_id, damage)
	
	remove_bullet.rpc()

@rpc("call_local")
func remove_bullet():
	queue_free()
