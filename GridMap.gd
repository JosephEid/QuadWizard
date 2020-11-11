extends GridMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(0, 10):
		set_cell_item(0, 0, i, 1, i)
		print(get_cell_item_orientation(0, 0, i))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
