extends CanvasLayer

var stats = []

func _ready():
	pass

func add_stat(stat_name, object, ref, is_method):
	stats.append([stat_name, object, ref, is_method])

func _process(_delta):
	var label_text = ""
	
	for s in stats:
		var value = null
		if s[1] and weakref(s[1]).get_ref():
			if s[3]:
				value = s[1].call(s[2])
			else:
				value = s[1].get(s[2])
		label_text += str(s[0], ": ", value)
		label_text += "\n"
	
	$Label.text = label_text
