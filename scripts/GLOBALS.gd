extends Node

@onready var game: Game = get_node("/root/Game")
@export var player: PlatformerController2D
@export var BULLET = preload("res://bullet/bullet.tscn")
@onready var LEVEL : Node2D = get_node("/root/Game/Level")

func is_network_authority(name: int) -> bool:
	return name == get_multiplayer_authority()
