extends Area2D

var hit_particle = preload("res://assets/particles/hit_particles.tscn").instance()

func _on_hitbox_area_entered(area):
	global.current_scene.add_child(hit_particle)
	hit_particle.global_position = global_position
