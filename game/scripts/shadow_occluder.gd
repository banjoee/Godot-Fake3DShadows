extends Area2D

onready var shadow = preload("res://assets/shadow.tscn")

var _area
var _new_shadow
var casting_shadows : int = 0
var shadows_to_delete : int = 0
var area_check : bool
var inside_area : bool

func _physics_process(delta):
	
	inside_area = casting_shadows > 0
	
	if casting_shadows > 0:
		_new_shadow.light_position = _area.global_position
	
	if get_child_count() == 1:
		shadows_to_delete = 0
	print(shadows_to_delete)


func _on_area2d_entered(area):
	casting_shadows += 1
	shadows_to_delete += 1
	_area = area
	if area.is_in_group("light"):
		for i in 1:
			var new_shadow = shadow.instance()
			add_child(new_shadow)
			_area = area
			_new_shadow = new_shadow

#func _on_area2d_exited(area):
#	casting_shadows -= 1
#	for n in 5:
#		print("removed")
#		remove_child(_new_shadow)

