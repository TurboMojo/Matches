extends Control

class_name card_selector

@export var card_deck = []
@export var used_cards = {}
var player : PlatformerController2D

var cardsToSpawn = 3
var selectable_cards = []
var cardsDrawn = 0

@onready var hand = get_node("/root/Game/UI/CardSelector")

@rpc("call_local")
func spawn_cards():	
	for n in cardsToSpawn:
		var rand = randi_range(0, card_deck.size()-1)
		var new_card = card_deck[rand].instantiate()
		new_card.name = "UpgradeCard"+str(cardsDrawn)
		var tempSelectableCards = {}
		tempSelectableCards["card"+str(tempSelectableCards.size())] = new_card		
		selectable_cards = tempSelectableCards
		#new_card.get_parent.remove_child(new_card)
		hand.add_child(new_card)
	hand.set_visible(true)

func start_card_selection():
	pass
	
func despawn_cards():
	for n in hand.get_children():
		hand.remove_child(n)
		n.queue_free()

func request_spawn_cards():
	print("request spawn cards")	
	rpc("spawn_cards")
