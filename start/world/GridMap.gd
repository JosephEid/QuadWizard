extends GridMap

# Declare member variables here
onready var player = get_node("/root/Game/Player")
onready var goal = get_node("../Goal")
#const ENEMY = preload("res://player/TESTENEMY.tscn")

var rand = RandomNumberGenerator.new()
var wall_y = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	clear()
	#Plot a grid of cells seperated by walls
	for x in range(-25, 26, 2):
		for z in range (-25, 26):
			set_cell_item(x,wall_y,z,0)
	for z in range(-25, 26, 2):
		for x in range (-25, 26):
			set_cell_item(x,wall_y,z,0)
	rand.randomize()
	var rand_x = rand.randi_range(-12, 12) * 2
	rand.randomize()
	var rand_z = rand.randi_range(-12, 12) * 2
	var starting_cell = Vector3(rand_x, wall_y, rand_z)

	var get_coords = map_to_world(starting_cell.x, 1, starting_cell.z)
	player.global_transform.origin = Vector3(get_coords.x,0,get_coords.z)
	
	recursive_backtracker(starting_cell)
	
	set_goal()
	
func add_enemy(enemy):
	
	rand.randomize()
	var rand_x = rand.randi_range(-12, 12) * 2
	rand.randomize()
	var rand_z = rand.randi_range(-12, 12) * 2
	var starting_cell = Vector3(rand_x, wall_y, rand_z)
	var get_coords = map_to_world(starting_cell.x, 1, starting_cell.z)
	get_parent().add_child(enemy)
	enemy.global_transform.origin = Vector3(get_coords.x, 0, get_coords.z)
	print(enemy.global_transform.origin)
	
	
func set_goal():
	rand.randomize()
	var goal_x = rand.randi_range(-12, 12) * 2
	rand.randomize()
	var goal_z = rand.randi_range(-12, 12) * 2
	var get_goal_coords = map_to_world(goal_x, 1, goal_z)
	goal.global_transform.origin = Vector3(get_goal_coords.x, get_goal_coords.y, get_goal_coords.z)


func recursive_backtracker(starting_cell) -> void:
	var stack = []
	var visited = []
	
	stack.push_front(starting_cell)
	visited.append(starting_cell)
	
	while (!stack.empty()):
		var current_cell = stack.pop_front()
		
		var unvisited = get_unvisited_neighbours(current_cell, visited)
		
		if !unvisited.empty():
			stack.push_front(current_cell)
			var random = unvisited[randi() %unvisited.size()]
			remove_wall(current_cell, random)
			visited.append(random[0])
			stack.push_front(random[0])
		else:
			rand.randomize()
			var rand_number = rand.randi_range(0, 100)
			if (rand_number <= 10):
				var walls = get_surrounding_walls(current_cell)
				if walls.size() == 3:
					var orient = []
					for i in range(walls.size()):
						orient.append(walls[i][1])
					if !orient.has("r"):
						set_cell_item(current_cell.x, 0, current_cell.z, 2, 0) #0 = 0
					elif !orient.has("l"):
						set_cell_item(current_cell.x, 0, current_cell.z, 2, 2) #2 = 180
					elif !orient.has("u"):
						set_cell_item(current_cell.x, 0, current_cell.z, 2, 22) #22 = -90
					elif !orient.has("d"):
						set_cell_item(current_cell.x, 0, current_cell.z, 2, 16) #16 = 90


func remove_wall(current, neighbour):
	var neighbour_ori = neighbour[1]
	if neighbour_ori == "r":
		set_cell_item(current.x+1, wall_y, current.z, -1)
	elif neighbour_ori == "l":
		set_cell_item(current.x-1, wall_y, current.z, -1)
	elif neighbour_ori == "u":
		set_cell_item(current.x, wall_y, current.z+1, -1)
	elif neighbour_ori == "d":
		set_cell_item(current.x, wall_y, current.z-1, -1)
		
func get_unvisited_neighbours(cell, visited):
	var x = cell[0]
	var z = cell[2]
	var neighbours = []

	if (x+2 < 25):
		if (!visited.has(Vector3(x+2, wall_y, z))): 
			neighbours.append([Vector3(x+2, wall_y, z), "r"])
	if (x-2 > -25):
		if (!visited.has(Vector3(x-2, wall_y, z))):
			neighbours.append([Vector3(x-2, wall_y, z), "l"])
	if (z+2 < 25):
		if (!visited.has(Vector3(x, wall_y, z+2))):
			neighbours.append([Vector3(x, wall_y, z+2), "u"])
	if (z-2 > -25):
		if (!visited.has(Vector3(x, wall_y, z-2))):
			neighbours.append([Vector3(x, wall_y, z-2), "d"])
	
	return neighbours


func get_surrounding_walls(cell):
	var x = cell[0]
	var z = cell[2]
	var neighbours = []
	
	if (get_cell_item(x+1, wall_y, z) == 0):
		if (x+1 < 26):
			neighbours.append([Vector3(x+1, wall_y, z), "r"])
	if (get_cell_item(x-1, wall_y, z) == 0):
		if (x-1 > -26):
			neighbours.append([Vector3(x-1, wall_y, z), "l"])
	if (get_cell_item(x, wall_y, z+1) == 0):
		if (z+1 < 26):
			neighbours.append([Vector3(x, wall_y, z+1), "u"])
	if (get_cell_item(x, wall_y, z-1) == 0):
		if (z-1 > -26):
			neighbours.append([Vector3(x, wall_y, z-1), "d"])
	
	return (neighbours)
