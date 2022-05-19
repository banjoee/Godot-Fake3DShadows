extends YSort

var Overlay
var is_raining = false

onready var rain = preload("res://assets/particles/rain_particles.tscn").instance()
onready var rain_drops = rain.get_node("DropParticles")

func _ready():
	var overlay = preload("res://ui/debug_overlay.tscn").instance()
	add_stats(overlay)
	add_child(overlay)

func _process(delta):
	if Input.is_action_just_pressed("ui_page_down"):
		if not is_raining:
			is_raining = true
		elif is_raining:
			is_raining = false
		
		if is_raining:
			var rain_intensity = round(rand_range(100, 1000))
			rain.amount = rain_intensity
			rain_drops.amount = rain_intensity / 5
			print(rain_intensity)
			global.current_scene.add_child(rain)
		else:
			global.current_scene.remove_child(rain)

func add_stats(overlay):
	overlay.add_stat("player position", $Player, "position", false)
