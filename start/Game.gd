extends Node


onready var final_menu : = $FinalMenu
onready var player : = $Player
onready var maze : = $"Level1/Maze"

var play_time : = 0.0
const ENEMY = preload("res://player/TESTENEMY.tscn")

func _ready():
	var enemy1 = ENEMY.instance()
	var enemy2 = ENEMY.instance()
	var enemy3 = ENEMY.instance()
	
	maze.add_enemy(enemy1)
	maze.add_enemy(enemy2)
	maze.add_enemy(enemy3)
	
func _process(delta : float) -> void:
	play_time += delta

func _on_Level1_level_completed():
	print("here")
	var total_play_time = play_time
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	player.queue_free()
	final_menu.initialize(total_play_time)


func _on_FinalMenu_retried():
	get_tree().reload_current_scene()
