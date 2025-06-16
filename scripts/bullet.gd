extends Area2D

var speed = 250

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_body_entered(body):
	if !is_multiplayer_authority():
		return
	
	if body is Player:
		body.take_damage.rpc_id(body.get_multiplayer_authority(), 25)
	
	remove_bullet.rpc()

@rpc("call_local")
func remove_bullet():
	queue_free()


#var velocity = Vector2.RIGHT
##var player_rot
##var damagedTarget
#@export var speed = 1000
#@export var damage = 1
#var bullets = []
#@export var player_id := 1:
#	set(id):
#		player_id = id

#func _ready():
	#print("bullet spawned")
#	visible = false
	
	#await %AnimatedSprite2D.get_tree().idle_frame
	#velocity = velocity.rotated(player_rot)
	#rotation = player_rot
#	visible = true


#func _process(delta):
#	position += transform.x * speed * delta

	
#@rpc("any_peer", "call_local", "reliable")
#func take_damage_rpc(remote_player_id: int, damagedTarget: NodePath):	
#	if remote_player_id != multiplayer.get_remote_sender_id():		
#		return

#	get_node(damagedTarget).take_damage(damage)
#	print("Bullet destroyed")	


#func _on_bullet_area_body_entered(body: Node2D) -> void:	
#	print("bullet hit something")
#	if 'take_damage' in body && body.player_id != player_id:
#		damagedTarget = body
#		rpc_id(1, 'take_damage_rpc', body.player_id, body.get_path())		
#	if multiplayer.is_server() or get_multiplayer_authority() == multiplayer.get_unique_id():
#		request_remove_bullet(player_id)
#	else:
#		rpc_id(1, "request_remove_bullet", player_id)
	

#@rpc("any_peer", "reliable")
#func request_remove_bullet(bullet_id: int):
	# Validate the request here
#	MultiplayerManager.remove_bullet.rpc(bullet_id)
