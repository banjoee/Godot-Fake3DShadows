extends Area2D

onready var hitbox = $CollisionShape2D
onready var player = get_parent()
onready var charge_timer = get_parent().get_node("Node2D/ChargeTimer")
onready var timer = get_parent().get_node("Node2D/AttackCooldown")

var knockback_vector = Vector2.ZERO
var charging = false
var elapsed_time = 0
var charged = false
var attacked = false
var hang_time : float
var critic_chance : float
var cooldown : float
var strength : float
var damage : float

func _physics_process(delta):
	
	global.strength = strength
	global.damage = damage
	hang_time = player.hang_time
	critic_chance = player.critic_chance
	cooldown = player.cooldown
	strength = player.strength
	damage = player.damage
	
	if Input.is_action_just_pressed("mouse_l"):
		charge_timer.start(0.6)
		if timer.is_stopped():
			if attacked != true:
				attacked = true
				var random_n = rand_range(0, 1)
				critic(random_n, cooldown)
				attack_hang_time(hang_time)
			timer.start(cooldown)
	
	if Input.is_action_pressed("mouse_l"):
		charged = elapsed_time >= 0.6
		if charge_timer.is_stopped():
			elapsed_time += delta
			charging = true
	
	if charging:
		if Input.is_action_just_released("mouse_l"):
			attacked = true
			charging = false
			if charged:
				critic(0, cooldown)
				charged_delay(0.1)
			attack_hang_time(hang_time)
			timer.start(cooldown)
	
	hitbox.disabled = not attacked
	global.attack_cooldown = cooldown
	
	look_at(get_global_mouse_position())

func critic(_random_n : float, _cooldown : float):
	if _random_n <= critic_chance:
		damage += damage / 2
	if charged:
		strength += clamp(strength * (clamp(elapsed_time, 0, 1.5) / 2), 0, 50) / 2
	critic_delay(_random_n, _cooldown)

func critic_delay(_random_n, _cooldown):
	yield(get_tree().create_timer(_cooldown), "timeout")
	if _random_n <= critic_chance:
		damage -= damage / 3

func attack_hang_time(_hang_time : float):
	yield(get_tree().create_timer(_hang_time), "timeout")
	attacked = false

func charged_delay(delay):
	yield(get_tree().create_timer(delay), "timeout")
	elapsed_time = 0
