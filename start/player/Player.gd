extends KinematicBody
class_name Player


var sens = 0.2
var accel = 8
var speed = 8
var vel = Vector3()
var previous_position = Vector3(0, 0, 0)
onready var player = get_node(".")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseMotion:
		var movement = event.relative
		
		rotation.y += -deg2rad(movement.x * sens)
		var proposed_x = rotation.x + (-deg2rad(movement.y * sens))
		if (proposed_x > -0.5 and proposed_x <0.5):
			$Pivot.rotation.x += -deg2rad(movement.y * sens)
		
func _physics_process(delta : float) -> void:
	var target_dir = Vector2(0, 0)
	if Input.is_action_pressed("forward"):
		target_dir.y -= 1
		print(player.global_transform.origin)
	if Input.is_action_pressed("backward"):
		target_dir.y += 1
	if Input.is_action_pressed("left"):
		target_dir.x -= 1
	if Input.is_action_pressed("right"):
		target_dir.x += 1
		

		
	target_dir = target_dir.normalized().rotated(-rotation.y)
	
	vel.x = lerp(vel.x, target_dir.x * speed, accel * delta)
	vel.z = lerp(vel.z, target_dir.y * speed, accel * delta)
	if (Input.is_action_pressed("forward") || Input.is_action_pressed("backward") 
		|| Input.is_action_pressed("left") || Input.is_action_pressed("right")):
		$Body.anim("Run")
		#rotation.y = 0.5*PI - h_motion.angle()
	else:
		$Body.anim("Idle")
		
	#rotation.y += rotate * rotate_speed * delta
	move_and_slide(vel, Vector3(0, 1, 0))
