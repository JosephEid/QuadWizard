extends KinematicBody
class_name Player

var sens = 0.2
var accel = 8
var speed = 8
var vel = Vector3()
var jump_speed = 12
var gravity = -30
var jump = false
var cooldown = 0
var health = 100

onready var player = get_node(".")
onready var maze = get_node("/root/Game/Level1/Maze")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

const SPELL = preload("res://player/Bullet.tscn")
	
func _input(event):
	if event is InputEventMouseMotion:
		var movement = event.relative
		rotation.y += -deg2rad(movement.x * sens)
		$Camera.rotation.x += -deg2rad(movement.y * sens)
		$Camera.rotation.x = clamp($Camera.rotation.x, -1.2, 1.2)

	if Input.is_action_just_pressed("mark"):
		var player_coords = player.global_transform.origin
		var current_cell = maze.world_to_map(Vector3(player_coords.x, 0, player_coords.z))
		maze.set_cell_item(current_cell.x, 0, current_cell.z, 1, 6)
		print(maze.get_cell_item_orientation(current_cell.x, 0, current_cell.z))
		
	jump = false
	if Input.is_action_just_pressed("jump"):
		jump = true
	
	if Input.is_action_just_pressed("cast") and !cooldown:
		var spell = SPELL.instance()
		spell.start($"TESTCHARACTER/metarig/Skeleton/Wand/WandBody/Position3D".global_transform)
		get_parent().get_parent().add_child(spell)
		$TESTCHARACTER.anim("Cast")
		cooldown = 100
		
func _physics_process(delta : float) -> void:
	
	cooldown -= 1
	cooldown = clamp(cooldown, 0, 100)
#	vel.y += gravity * delta
#
#	if jump && is_on_floor():
#		vel.y = jump_speed
		
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
		$TESTCHARACTER.anim("Run")
#	else:
#		$Body.anim("Idle")
		
	move_and_slide(vel, Vector3(0, 1, 0))

func get_health():
	
	return health
