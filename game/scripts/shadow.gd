extends Sprite

onready var hurtbox = get_parent()
onready var h_collision = hurtbox.get_node("CollisionShape2D")

var light_position : Vector2

func _physics_process(delta):
	var new_alpha = 0.75 / (hurtbox.casting_shadows + 1) * 1.25
	var direction = light_position.direction_to(global_position)
	var distance = light_position.distance_to(global_position)
	
	modulate.a = lerp(modulate.a, new_alpha, 0.1)
	
	position.x = hurtbox.position.y * direction.x * (offset.y / 15)
	position.y = hurtbox.position.y * direction.y * (offset.y / 15)
	
	if direction.y < 0:
		rotation_degrees = 90 * direction.x
	else:
		rotation_degrees = 90 * -direction.x + 180
	
	material.set("shader_param/shadowlength", distance / 10)
