extends "res://scripts/entity/entity_base.gd"

func _ready():
	dimension = Vector2(10, 10)

func _process(delta):
	effects.play("fly_pattern_1")
	animator.play("idle")
