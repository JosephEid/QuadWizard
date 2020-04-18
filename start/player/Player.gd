extends KinematicBody
class_name Player


var sens = 0.2
var accel = 8
var speed = 8
var vel = Vector3()
var jump_speed = 12
var gravity = -30
var jump = false
var cooldown = 100

onready var player = get_node(".")
onready var maze = get_node("/root/Game/Level1/Maze")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseMotion:
		var movement = event.relative
		rotation.y += -deg2rad(movement.x * sens)
		$Pivot.rotation.x += -deg2rad(movement.y * sens)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)
	
#	if Input.is_action_just_pressed("cast"):
#		var spell = SPELL.instance()
#		spell.start($Position3D.global_transform)
#		get_parent().add_child(spell)
#		print ("cast!!!")

	if Input.is_action_just_pressed("mark"):
		var player_coords = player.global_transform.origin
		var current_cell = maze.world_to_map(Vector3(player_coords.x, 0, player_coords.z))
		maze.set_cell_item(current_cell.x, 0, current_cell.z, 1)
		
	jump = false
	if Input.is_action_just_pressed("jump"):
		jump = true
		
func _physics_process(delta : float) -> void:
	cooldown -= 1
	vel.y += gravity * delta
	
	if jump && is_on_floor():
		vel.y = jump_speed
		
	var target_dir = Vector2(0, 0)
	
	if Input.is_action_pressed("forward"):
		target_dir.y -= 1
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
	else:
		$Body.anim("Idle")
		
	move_and_slide(vel, Vector3(0, 1, 0))
