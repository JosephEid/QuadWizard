extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player = get_node("/root/Game/Player")
onready var goal = get_node("/root/Game/Level1/Goal")

# Called when the node enters the scene tree for the first time.
func _process(delta):
	if (is_instance_valid(player) && is_instance_valid(goal)):
		
		set_text("Your current position is: " + str(player.global_transform.origin) + "\n Goal: " + str(goal.global_transform.origin))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
