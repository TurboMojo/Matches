extends NetworkWeapon2D
class_name BrawlerWeapon

@export var projectile: PackedScene
@export var fire_cooldown: float = 0.15
@export var input : PlayerInput
#@onready var input: PlayerInput = $"../../Input"
@onready var sound: AudioStreamPlayer2D = $AudioStreamPlayer2D

var last_fire: int = -1

static var _logger := _NetfoxLogger.new("fb", "BrawlerWeapon")
@export var player_id := 1:
	set(id):
		player_id = id
		
		
func _ready():
	NetworkTime.on_tick.connect(_tick)

func _can_fire() -> bool:
	return NetworkTime.seconds_between(last_fire, NetworkTime.tick) >= fire_cooldown

func _can_peer_use(peer_id: int) -> bool:
	return peer_id == input.get_multiplayer_authority()

func _after_fire(projectile: Node2D):
	var bullet := projectile as Bullet
	last_fire = get_fired_tick()
	if sound:
		sound.play()

	_logger.trace("[%s] Ticking new bomb %d -> %d" % [bullet.name, get_fired_tick(), NetworkTime.tick])
	for t in range(get_fired_tick(), NetworkTime.tick):
		if bullet.is_queued_for_deletion():
			break
		bullet._tick(NetworkTime.ticktime, t)

func _spawn() -> Node2D:
	var bomb_projectile: Bullet = projectile.instantiate() as Bullet
	get_tree().root.add_child(bomb_projectile, true)
	bomb_projectile.global_transform = global_transform
	bomb_projectile.fired_by = get_parent()

	return bomb_projectile

func _tick(_delta: float, _t: int):
	if input.is_firing:
		fire()
