extends KinematicBody2D

onready var sprite = $Sprite
onready var animator = $AnimationPlayer
onready var hurtbox = $Hurtbox
onready var hurtbox_area = $Hurtbox/CollisionShape2D
onready var collision = $CollisionShape2D
onready var effects = $Effects

export var max_life : float
export var knockback_resistance : float
export var dimension : Vector2
export var is_immovable : bool
export var is_fragile : bool
export var is_flying : bool

func _physics_process(delta):
	
	sprite.global_position = hurtbox.global_position
	collision.disabled = hurtbox.position.y < -dimension.y
	hurtbox_area.disabled = collision.disabled
	
	if hurtbox.life <= 0:
		queue_free()
	
	if !is_immovable:
		move_and_slide(hurtbox.knockback * hurtbox.knockback_strength / 2)
		get_knockback()
	
	if hurtbox.damaged:
		whiten(0.1)
		if !is_immovable or !is_flying:
			bounce(clamp((-hurtbox.knockback_strength) / 2, -INF, -1))
			animator.play("bounce")

func get_knockback():
	hurtbox.knockback = lerp(hurtbox.knockback, Vector2.ZERO, 0.1)

func bounce(strength):
	if !is_flying:
		animator.get_animation("bounce").track_set_key_value(0, 1, Vector2(0, strength))
	else:
		animator.get_animation("bounce").track_set_key_value(0, 1, Vector2(0, 0))

func whiten(delay):
	sprite.material.set("shader_param/whiten", true)
	yield(get_tree().create_timer(delay), "timeout")
	sprite.material.set("shader_param/whiten", false)
