class_name Game
extends Node

@onready var multiplayer_ui = $UI/Multiplayer

const PLAYER = preload("res://player/platformer_player.tscn")
#const PLAYER = preload("res://player/player.tscn")
var peer = ENetMultiplayerPeer.new()
var players: Array[PlatformerController2D] = []
var dead_players: Array[PlatformerController2D] = []
#var players: Array[Player] = []
var _players_spawn_node
var _player_spawn_points
var bullet_scene = preload("res://scenes/bullet.tscn")
var card_selector
var card_hand
var bullets = {}
@export var upgrade_cards : Array[Resource]
var currentWinner : int

var roundWinners: Array[CharacterBody2D]
var currentRound = 0
var selection_options = 3
@export var bullets_fired = 0
@export var graveyard : Node2D

var next_player_name = "Player 1"

func _ready():
	graveyard = get_node("/root/Game/Graveyard")
	$MultiplayerSpawner.spawn_function = add_player
	_player_spawn_points = $/root/Game/Level
	_players_spawn_node = $/root/Game
	
	card_selector = $/root/Game/UI/CardSelector
	card_hand = $/root/Game/UI/CardSelector/Hand
	
	for card_path in DirAccess.get_files_at("res://cards/"):
		upgrade_cards.append(load("res://cards/"+card_path))
	
	if _players_spawn_node == null:
		print("Cant find players")

func _on_host_pressed():
	
	peer.create_server(25565)
	multiplayer.multiplayer_peer = peer
	
	multiplayer.peer_connected.connect(
		func(pid):
			print("Peer " + str(pid) + " has joined the game!")
			$MultiplayerSpawner.spawn(pid)
	)
	
	$MultiplayerSpawner.spawn(multiplayer.get_unique_id())
	multiplayer_ui.hide()

func _on_join_pressed():
	next_player_name = "Player" + str(multiplayer.get_peers().size())
	peer.create_client("localhost", 25565)
	multiplayer.multiplayer_peer = peer
	multiplayer_ui.hide()

func add_player(pid):
	var player = PLAYER.instantiate()
	player.name = str(pid)
	player.player_name = next_player_name
	next_player_name = ""
	player.global_position = $Level.get_child(players.size()).global_position
	players.append(player)
	if multiplayer.get_peers().size() > 1:
		player.player_name = "Player"+str((multiplayer.get_peers().size))
	else:
		player.player_name = "Host"
	return player

func get_random_spawnpoint():
	return $Level.get_children().pick_random().global_position

@rpc("call_local", "any_peer")
func spawn_cards():
	print("spawn_cards")
	for count in selection_options:		
		var card = upgrade_cards.pick_random()
		if card != null:
			#print("card: ", card.name)
			var new_card = card.instantiate()
			card_hand.add_child(new_card)
		else:
			print("card is null")

	
func despawn_cards():
	for n in card_hand.get_children():
		card_hand.remove_child(n)
		n.queue_free()

func player_death(dead_player: PlatformerController2D):
	var last_living_player: PlatformerController2D	
	dead_players.append(dead_player)
	print (players.size(), " players")
	print (dead_players.size(), " dead players")
	for dp in dead_players:
		print(dp.player_name+" is dead")
	for player in players:
		if not dead_players.has(player):
			print("Winner is "+player.player_name)
			last_living_player = player
	
	if last_living_player != null:
		roundWinners.append(last_living_player)
		var victory_count = roundWinners.count(last_living_player)
		currentWinner = last_living_player.multiplayer.get_unique_id()
		dead_players.clear()
		if victory_count % 2 == 0:			
			rpc_id(currentWinner, "spawn_cards")
	else:
		print("last_living_player is null")
