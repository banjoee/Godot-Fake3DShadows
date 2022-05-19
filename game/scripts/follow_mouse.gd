extends Light2D

onready var shadow = preload("res://assets/shadow.tscn")

func _process(delta):
	global_position = get_global_mouse_position()
