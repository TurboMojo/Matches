extends Control

class_name card_selector

@export var card_deck = []
@export var used_cards = {}
var player : PlatformerController2D

var cardsToSpawn = 3
var selectable_cards = []
var cardsDrawn = 0

@onready var hand = get_node("/root/Game/UI/CardSelector")


func start_card_selection():
	pass
	
func despawn_cards():
	pass
	#for n in hand.get_children():
	#	hand.remove_child(n)
	#	n.queue_free()
