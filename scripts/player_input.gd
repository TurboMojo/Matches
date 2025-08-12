# player_input.gd
extends MultiplayerSynchronizer

#Input Variables for the whole script
@export var upHold : bool
@export var downHold : bool
@export var leftHold : bool
@export var leftTap : bool
@export var leftRelease : bool
@export var rightHold : bool
@export var rightTap : bool
@export var rightRelease : bool
@export var jumpTap : bool
@export var jumpRelease : bool
@export var runHold : bool
@export var latchHold : bool
@export var dashTap : bool
@export var rollTap : bool
@export var downTap : bool
@export var twirlTap : bool

func _ready():
	# Only process for the local player.
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())



func _process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	pass

func _physics_process(delta):
	#if get_multiplayer_authority() != multiplayer.get_unique_id():
	#	return
	#INFO Input Detectio. Define your inputs from the project settings here.
	leftHold = Input.is_action_pressed("left")
	rightHold = Input.is_action_pressed("right")
	upHold = Input.is_action_pressed("up")
	downHold = Input.is_action_pressed("down")
	leftTap = Input.is_action_just_pressed("left")
	rightTap = Input.is_action_just_pressed("right")
	leftRelease = Input.is_action_just_released("left")
	rightRelease = Input.is_action_just_released("right")
	jumpTap = Input.is_action_just_pressed("jump")
	jumpRelease = Input.is_action_just_released("jump")
	runHold = Input.is_action_pressed("run")
	latchHold = Input.is_action_pressed("latch")
	dashTap = Input.is_action_just_pressed("dash")
	rollTap = Input.is_action_just_pressed("roll")
	downTap = Input.is_action_just_pressed("down")
	twirlTap = Input.is_action_just_pressed("twirl")
