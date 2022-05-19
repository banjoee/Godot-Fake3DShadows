extends Area2D


onready var parent = get_parent()
onready var animator = get_parent().get_node("AnimationPlayer")
onready var collision = $CollisionShape2D
onready var max_life : float
onready var knockback_resistance : float

var life : float
var direction : Vector2
var knockback : Vector2
var knockback_strength : int
var damaged = false

func _ready():
	max_life = parent.max_life
	knockback_resistance = parent.knockback_resistance
	life = max_life

func _process(delta):
	max_life = parent.max_life
	knockback_resistance = parent.knockback_resistance
	damaged = false

func _on_hurtbox_area_entered(area):
	if area.is_in_group("hitbox"):
		damaged = true
		life -= area.damage
		knockback_strength = area.strength
		detect_knockback(area.global_position, area.strength, area.damage, area.get_parent().velocity)

func detect_knockback(damage_source_position : Vector2, damage_source_strength : float, damage_received : float, damage_source_speed : Vector2):
	direction = damage_source_position.direction_to(global_position)
	knockback_strength -= knockback_resistance
	knockback = (direction * knockback_strength) + (damage_source_speed / 10)
