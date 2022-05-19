extends Node

var max_speed = 65
var velocity = Vector2.ZERO
var gravity = 50
var acceleration = 10
var input = Vector2.ZERO
var last_input : Vector2
var current_scene
var attack_cooldown : float
var strength : float
var damage : float

func _physics_process(delta):
	current_scene = get_tree().current_scene
	input.x = Input.get_axis("ui_left", "ui_right")
	input.y = Input.get_axis("ui_up", "ui_down")
	velocity = lerp(velocity, input.normalized() * max_speed, acceleration * delta)
	if input != Vector2.ZERO:
		last_input = input

func frame_freeze(time_scale : float, duration : float):
	Engine.time_scale = time_scale
	yield(get_tree().create_timer(time_scale * duration), "timeout")
	Engine.time_scale = 1.0

func timeout_timer(time : float):
	yield(get_tree().create_timer(time), "timeout")
