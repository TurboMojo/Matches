class_name Game
extends Node

@onready var multiplayer_ui = $UI/Multiplayer

const PLAYER = preload("res://player/platformer_player.tscn")
#const PLAYER = preload("res://player/player.tscn")
var peer = ENetMultiplayerPeer.new()
var players: Array[PlatformerController2D] = []
#var players: Array[Player] = []
var _players_spawn_node
var _player_spawn_points
var bullet_scene = preload("res://scenes/bullet.tscn")
var card_selector
var bullets = {}

var currentWinner : int

var roundWinners = {}
var currentRound = 0
@export var bullets_fired = 0
@export var graveyard : Node2D

func _ready():
	graveyard = get_node("/root/Graveyard")
	$MultiplayerSpawner.spawn_function = add_player
	_player_spawn_points = $/root/Game/Players/SpawnPoints
	_players_spawn_node = $/root/Game/Players
	card_selector = $/root/Game/UI/CardSelector
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
	peer.create_client("localhost", 25565)
	multiplayer.multiplayer_peer = peer
	multiplayer_ui.hide()

func add_player(pid):
	var player = PLAYER.instantiate()
	player.name = str(pid)
	player.global_position = $Level.get_child(players.size()).global_position
	players.append(player)
	
	return player

func get_random_spawnpoint():
	return $Level.get_children().pick_random().global_position
	
func player_death(dead_player: PlatformerController2D):
	var living_players = 0
	var last_living_player
	for p in players:
		if p.health >= 0:
			living_players += 1
			last_living_player = p
			
		if(living_players == 1):			
			roundWinners[roundWinners.size()] = last_living_player
			var victory_count = roundWinners.count(last_living_player)
			currentWinner = last_living_player.multiplayer.get_unique_id()
			if victory_count % 2 == 0:
				last_living_player.show_card_select(card_selector)
