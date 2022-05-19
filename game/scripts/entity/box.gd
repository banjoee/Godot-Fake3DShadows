extends "res://scripts/entity/entity_base.gd"

var break_particles = preload("res://assets/particles/break_particles.tscn").instance()

func _ready():
	max_life = 5
	knockback_resistance = 0
	dimension = Vector2(15, 15)

func _physics_process(delta):
	if hurtbox.life <= 0:
		get_tree().current_scene.add_child(break_particles)

func _on_hurtbox_area_entered(area):
	if area.is_in_group("hitbox"):
		break_particles.global_position = hurtbox.global_position
		break_particles.process_material.direction = Vector3(hurtbox.direction.x, -1, 0)
		break_particles.process_material.initial_velocity = clamp((area.strength + area.damage) * 10, 150, INF)
