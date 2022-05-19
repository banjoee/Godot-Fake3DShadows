extends KinematicBody2D

var max_speed = global.max_speed
var new_max_speed : float
var velocity = global.velocity
var gravity = global.gravity
var acceleration = global.acceleration
var input = global.input
var local_mouse
var is_attacking : bool
var attacked = false
var is_sprinting : bool
var last_input : Vector2
var is_backwards : bool
var is_moving : bool

var state = WALK
enum {
	WALK,
	ATTACK,
	SPRINT,
	ROLL
}

onready var animTree = $AnimationTree
onready var animState = animTree.get("parameters/playback")
onready var animPlayer = $AnimationPlayer
onready var shovel = $YSort/ShovelPivot/Shovel
onready var animShovel = $YSort/ShovelPivot/Shovel/ShovelAnimation
onready var animTreeShovel = $YSort/ShovelPivot/Shovel/ShovelAnimationTree
onready var position_2d = $YSort/ShovelPivot
onready var animStateShovel = animTreeShovel.get("parameters/attacks/playback")
onready var timer = $Node2D/ShovelHangtime
onready var roll_timer = $Node2D/RollTimer
onready var hitbox = $Hitbox
onready var hitbox_collision = $Hitbox/CollisionShape2D

export var max_life = 10
export var hang_time = 0.04
export var critic_chance = 0.05
export var cooldown = 0.6
export var strength = 10.0
export var damage = 1.0
export var can_use_shovel = true

func _ready():
	animTree.active = true

func _physics_process(delta):
	
	local_mouse = get_local_mouse_position()
	is_attacking = Input.is_action_pressed("mouse_l")
	is_sprinting = Input.is_action_pressed("shift")
	hitbox.monitorable = can_use_shovel
	
	match state:
		WALK:
			movement(delta, 65, 0.05, 10)
		ATTACK:
			attack(delta)
		SPRINT:
			sprint(delta)
		ROLL:
			roll()
	
	if is_attacking and can_use_shovel:
		timer.start(0.6)
		if timer.is_stopped():
			timer.start(0.6)
	
	states_decider()
	animations()

func movement(delta, _new_max_speed, lerp_value, _acceleration):
	input.x = Input.get_axis("ui_left", "ui_right")
	input.y = Input.get_axis("ui_up", "ui_down")
	is_moving = input != Vector2.ZERO
	
	max_speed = lerp(max_speed, _new_max_speed, lerp_value)
	velocity = lerp(velocity, input.normalized() * max_speed, _acceleration * delta)
	move_and_slide(velocity)

func attack(delta):
	movement(delta, 30, 0.2, 10)

func sprint(delta):
	movement(delta, 115, 0.05, 7.5)

func roll():
	velocity = move_and_slide(lerp(input, input * 1000, 1))

func states_decider():
	var is_rolling = false
	if not is_rolling:
		state = WALK
		if Input.is_action_pressed("shift"):
			state = SPRINT
		if is_attacking and can_use_shovel:
			state = ATTACK
	else:
		state = ROLL
	
	if Input.is_action_just_pressed("space"):
		roll_timer.start(5.0)
		is_rolling = true
		if roll_timer.is_stopped():
			is_rolling = false
			roll_timer.start(5.0)

func animations():
	var mouse_round = Vector2(round(local_mouse.x), round(local_mouse.y))
	is_backwards = input * mouse_round > Vector2.ZERO
	
	if not is_attacking:
		animTree.set("parameters/walk/blend_position", velocity.normalized())
		animTree.set("parameters/idle/idle/blend_position", last_input)
	elif can_use_shovel:
		animTree.set("parameters/walk/blend_position", local_mouse)
		animTree.set("parameters/idle/idle/blend_position", local_mouse)
	
	animTree.set("parameters/sprint/sprint/blend_position", velocity.normalized())
	animTree.set("parameters/sprint/sprint_speed/scale", 1)
	animTree.set("parameters/idle/is_sprinting/current", is_sprinting)
	animTreeShovel.set("parameters/attacks/conditions/hand_switched", _hand_switch())
	
	if timer.is_stopped():
		if input != Vector2.ZERO:
			last_input = input
			if max_speed > 100:
				animState.travel("sprint")
			else:
				animState.travel("walk")
		else:
			animState.travel("idle")
	elif can_use_shovel:
		animTree.set("parameters/strafe/is_backwards/current", is_backwards)
		animTree.set("parameters/strafe/is_moving/current", input == Vector2.ZERO)
		animTree.set("parameters/strafe/TimeScale/scale", 0.7)
		animTree.set("parameters/strafe/strafe_idle/blend_position", mouse_round)
		animTree.set("parameters/strafe/strafe_bakwards/blend_position", mouse_round)
		animTree.set("parameters/strafe/strafe_forwards/blend_position", mouse_round)
		animState.travel("strafe")
		last_input = mouse_round
	
	shovel.visible = !timer.is_stopped()
	if abs(local_mouse.x) > abs(local_mouse.y):
		shovel.flip_v = false
		shovel.rotation_degrees = 0
		if local_mouse.x > 0:
			shovel.flip_h = true
			shovel.flip_v = false
		else:
			shovel.flip_h = false
			shovel.flip_v = true
	else:
		shovel.flip_h = false
		shovel.rotation_degrees = 90
		if local_mouse.y > 0:
			shovel.flip_h = true
			shovel.flip_v = false
		else:
			shovel.flip_h = false
			shovel.flip_v = true
	
	shovel_y_sort()


func _hand_switch():
	var hand_switch : bool
	if not Input.is_action_pressed("mouse_l"):
		if Input.is_action_just_pressed("mouse_l"):
			if hand_switch == true:
				hand_switch = false
			else:
				hand_switch = true
	else:
		if !hitbox_collision.disabled:
			hand_switch = true
	if !hitbox_collision.disabled:
		hand_switch = true
	return hand_switch

func shovel_y_sort():
	var normal_mouse = local_mouse.normalized()
	if abs(normal_mouse.x) > abs(normal_mouse.y):
		if normal_mouse.x < 0:
			if animStateShovel.get_current_node() == "attack_1":
				position_2d.position = Vector2.DOWN
			else:
				position_2d.position = Vector2.ZERO
		else:
			if animStateShovel.get_current_node() == "attack_1":
				position_2d.position = Vector2.ZERO
			else:
				position_2d.position = Vector2.DOWN
	else:
		if normal_mouse.y > 0:
			position_2d.position = Vector2.DOWN
		else:
			position_2d.position = Vector2.ZERO
