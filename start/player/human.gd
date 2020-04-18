extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var cooldown = 0
const SPELL = preload("res://player/Bullet.tscn")

func _input(event):
	if Input.is_action_just_pressed("cast") and !cooldown:
		var spell = SPELL.instance()
		spell.start($"Human Armature/Position3D".global_transform)
		get_parent().get_parent().add_child(spell)
		cooldown = 100
		
func _process(delta):
	cooldown -= 1
	cooldown = clamp(cooldown, 0, 100)
	
func anim(a):
	var anim = $"Human Armature/AnimationPlayer"
	if anim.current_animation != a:
		anim.play(a)
