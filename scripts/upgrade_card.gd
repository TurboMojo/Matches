extends Node

class_name upgrade_card

@onready var player : PlatformerController2D # = get_parent().get_parent().get_parent()
@export_range(0, 5) var jumpHeightMultiplier : float = 1.0 
@export var jumps : int = 1
@export var gravityScaleMultiplier : float = 1.0
@export var terminalVelocity : float = 500.0
@export var descendingGravityFactor : float = 1.3
@export var variableJumpHeight : bool = true
@export var coyoteTimeMultiplier : float = 1.0
@export var jumpBufferingMultiplier : float = 1.0
@export var wallJump : bool = true
@export var inputPauseAfterWallJump : float = 0.1
@export var wallKickAngle : float = 60.0
@export var wallSliding : float = 1.0
@export var wallLatching : bool = false
@export var wallLatchingModifer : bool = false
@export_enum("None", "Horizontal", "Vertical", "Four Way", "Eight Way") var dashType: int
@export var dashes : int = 1
@export var dashCancel : bool = true
@export var dashLength : float = 2.5
@export var cornerCutting : bool = false
@export var correctionAmount : float = 1.5
@export var crouch : bool = false
@export var canRoll : bool = false
@export var rollLength : float = 2.0
@export var groundPound : bool = false
@export var groundPoundPause : float = 0.25
@export var upToCancel : bool = false

var cardSelector : card_selector
@onready var game: Game = get_node("/root/Game")

#func _ready() -> void:
	#print(get_parent().get_parent().get_parent())

func ApplyUpgrade():    
	# Apply upgrade stats to player
	#MultiplayerManager.game.cardSelector.select_card(self)
	#print("Upgrade applied!")
	#self.parent.visible = false
	#self.visible = false
	#if MultiplayerManager.currentWinner == multiplayer.get_unique_id():
	#	rpc_id(1, "request_apply_upgrade")
	#else:
	#	MultiplayerManager.game.cardHand.visible = false
	#	request_apply_upgrade()
	rpc("request_apply_upgrade")
	print("Requesting to apply upgrade over the network")

@rpc("call_local")
func request_apply_upgrade():	
	game.despawn_cards()
	#pass
	#if game.currentWinner == multiplayer.get_unique_id():
	#	game.card_selector.visible = false
	#	print("Upgrade applied on server!")
	#elif !multiplayer.is_server():
	#	game.card_selector.visible = false
	#	print("Upgrade applied on server!")
	#else:
	#	print("Upgrade not applied")


#func _on_button_mouse_entered() -> void:	
	#MultiplayerManager.game.isSelectingCard = true


#func _on_button_mouse_exited() -> void:	
	#MultiplayerManager.game.isSelectingCard = false
