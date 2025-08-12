extends Node

@onready var game: Game = get_node("/root/Game")
@export var player: PlatformerController2D
@export var BULLET = preload("res://bullet/bullet.tscn")
