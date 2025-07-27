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
#var card_selector
@onready var card_hand = get_node("/root/Game/UI/CardSelector")
var bullets = {}
@export var upgrade_cards : Array[Resource]
@export var currentWinner : int
@export var isSelectingCard = false
var roundWinners: Array[PlatformerController2D]
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
	player.set_multiplayer_authority(pid)
	player.name = str(pid)
	player.player_name = str(pid)
	player.player_id =  pid
	next_player_name = ""
	player.global_position = $Level.get_child(players.size()).global_position
	players.append(player)
	print(str(players.size())+" players")
	
	if multiplayer.get_peers().size() > 0:	
		player.player_name = "Player 2"
	else:
		player.player_name = "Host"
	return player

func get_random_spawnpoint():
	return $Level.get_children().pick_random().global_position

@export var isCardSelection = false

@rpc("call_local", "any_peer")
func spawn_cards(winner: int):		
	var winnerObject = get_body_from_id(winner)
	if winnerObject == null:
		print("winner is null")
		return
	#print("winner: "+str(winnerObject.player_name)+" multiplayer_id: "+str(multiplayer.get_unique_id()))
	print()
	if get_id_from_body(winnerObject) != multiplayer.get_unique_id():
		print("not me, returning")
		return
	print("me")
	card_hand = get_node("/root/Game/UI/CardSelector")
	isCardSelection = true
	if winnerObject == null:
		print("winner is null")
		return
	for count in selection_options:		
		var card = upgrade_cards.pick_random()
		if card != null:
			var new_card = card.instantiate()
			if card_hand == null:
				print ("card_hand is null")
				return
			card_hand.add_child(new_card)
		else:
			print("card is null")

		
@rpc("any_peer", "call_local")
func take_damage(player_id: int, amount: int):
	var body = get_body_from_id(player_id)
	body.health -= amount	
	if body.health <= 0:		
		body.global_position = get_random_spawnpoint()
		player_death(body)
		#health = MAX_HEALTH
		
func get_body_from_id(player_id:int):
	for player in players:
		if player.get_multiplayer_authority() == player_id:
			return player
			
func get_id_from_body(body: PlatformerController2D):
	for player in players:
		if(player == body):
			return player.player_id

func player_death(dead_player: PlatformerController2D):
	var last_living_player: PlatformerController2D
	dead_players.append(dead_player)
	for player in players:
		if not dead_players.has(player):			
			last_living_player = player	
	
	if last_living_player != null:
		# I'm not sure why this is in an if block, but I don't feel like finding out right now.
		# TODO: test and see if this if statement is needed and remove it if not.
		roundWinners.append(last_living_player)
		var victory_count = roundWinners.count(last_living_player)
		currentWinner = last_living_player.player_id		
		print("Winner is "+last_living_player.player_name)
		#dead_players.clear()
		if victory_count % 2 == 0:
			rpc_id(currentWinner,"spawn_cards", currentWinner)
