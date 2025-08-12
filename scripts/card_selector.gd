extends Control

class_name card_selector

@export var card_deck = []
@export var used_cards = {}
var player : PlatformerController2D

var cardsToSpawn = 3
var selectable_cards = []
var cardsDrawn = 0

@onready var hand = get_node("/root/Game/UI/CardSelector")
@onready var game: Game = get_node("/root/Game")

func start_card_selection():
	pass
	
func despawn_cards():
	game.isCardSelection = false
	for n in hand.get_children():
		hand.remove_child(n)
		n.queue_free()
	for dead_player in game.dead_players:	
		rpc_id(1, "game.respawn", dead_player)
