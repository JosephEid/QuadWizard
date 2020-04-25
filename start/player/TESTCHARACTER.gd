extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


#var cooldown = 0
#const SPELL = preload("res://player/Bullet.tscn")
#
#func _input(event):
#	if Input.is_action_just_pressed("cast") and !cooldown:
#		var spell = SPELL.instance()
#		spell.start($"Position3D".global_transform)
#		get_parent().get_parent().add_child(spell)
#		anim("Cast")
#		cooldown = 100
#
#func _process(delta):
#	cooldown -= 1
#	cooldown = clamp(cooldown, 0, 100)
	
func anim(a):
	var anim = $"AnimationPlayer"
	if anim.current_animation != a:
		anim.play(a)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
