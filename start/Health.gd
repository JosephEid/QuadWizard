extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


onready var player = get_node("/root/Game/Player")

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	if (is_instance_valid(player)):
		
		set_text("Health: " + str(player.get_health()))
