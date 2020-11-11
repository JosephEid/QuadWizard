extends GridMap

# Declare member variables here
onready var player = get_node("/root/Game/Player")
onready var goal = get_node("../Goal")
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

	#Start a randomized prim's algorithm to generate paths through the walls
#	prims_algorithm(starting_cell)
#	place_chests()
	var get_coords = map_to_world(starting_cell.x, 1, starting_cell.z)
	player.global_transform.origin = Vector3(get_coords.x,10,get_coords.z)
	recursive_backtracker(starting_cell)
	set_goal()

func set_goal():
	rand.randomize()
	var goal_x = rand.randi_range(-12, 12) * 2
	rand.randomize()
	var goal_z = rand.randi_range(-12, 12) * 2
	var get_goal_coords = map_to_world(goal_x, 1, goal_z)
	goal.global_transform.origin = Vector3(get_goal_coords.x, get_goal_coords.y, get_goal_coords.z)


#func place_chests():
#	pass
#	for x in range(-24, 26, 2):
#		for z in range(-24, 26, 2):
#
#			var get_walls = get_surrounding_walls(Vector3(x, 0, z))
#
#			if (get_walls[1] == 3):
#
#				rand.randomize()
#				var rand_number = rand.randi_range(0, 100)
#				if (rand_number <= 50):
#					set_cell_item(x, 0, z, 2, 1)
					
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
			if get_surrounding_walls(current_cell).size() == 3:
				rand.randomize()
				var rand_number = rand.randi_range(0, 100)
				if (rand_number <= 50):
					set_cell_item(current_cell.x, 0, current_cell.z, 2)


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


func prims_algorithm(starting_cell) -> void:
	#Initialize start by selecting a random starting cell.
	var wall_list = []
	print (starting_cell)
	var starting_cell_walls = get_surrounding_walls(starting_cell)[0]
	var get_coords = map_to_world(starting_cell.x, 1, starting_cell.z)
	print (get_coords)
	player.global_transform.origin = Vector3(get_coords.x,0,get_coords.z)
	#Add the walls surrounding the starting cell to the list of walls.
	for i in range(len(starting_cell_walls)):
		wall_list.append(starting_cell_walls[i])
	
	#Initialize a list of visited cells and add the starting cell to it.	
	var visited_cells = []
	visited_cells.append(starting_cell)
	
	while (wall_list.size() != 0):
		var wall = wall_list[randi() % wall_list.size()]
		var adj_cells = get_adj_cells(wall)
		var wall_coords = wall[0]
		
		if (visited_cells.has(adj_cells[0]) && !visited_cells.has(adj_cells[1])):
			visited_cells.append(adj_cells[1])
			var cell_walls = get_surrounding_walls(adj_cells[1])[0]
			for i in range(len(cell_walls)):
				wall_list.append(cell_walls[i])
			set_cell_item(wall_coords.x, wall_coords.y, wall_coords.z, -1)
		elif (visited_cells.has(adj_cells[1]) && !visited_cells.has(adj_cells[0])):
			visited_cells.append(adj_cells[0])
			var cell_walls = get_surrounding_walls(adj_cells[0])[0]
			for i in range(len(cell_walls)):
				wall_list.append(cell_walls[i])
			set_cell_item(wall_coords.x, wall_coords.y, wall_coords.z, -1)

		var wall_index = wall_list.find(wall)
		wall_list.remove(wall_index)
		

func get_adj_cells(wall):
	
	var wall_coords = wall[0]
	var wall_ori = wall[1]
	var x = wall_coords[0]
	var z = wall_coords[2]
	
	if (wall_ori == "r" || wall_ori == "l"):
		return [Vector3(x-1, wall_y, z), Vector3(x+1, wall_y, z)]
	else:
		return [Vector3(x, wall_y, z-1), Vector3(x, wall_y, z+1)]


func get_surrounding_walls(cell):
	var x = cell[0]
	var z = cell[2]
	var neighbours = []
	
	if (get_cell_item(x+1, wall_y, z) == 0):
		if (x+1 != 25):
			neighbours.append([Vector3(x+1, wall_y, z), "r"])
	if (get_cell_item(x-1, wall_y, z) == 0):
		if (x-1 != -25):
			neighbours.append([Vector3(x-1, wall_y, z), "l"])
	if (get_cell_item(x, wall_y, z+1) == 0):
		if (z+1 != 25):
			neighbours.append([Vector3(x, wall_y, z+1), "u"])
	if (get_cell_item(x, wall_y, z-1) == 0):
		if (z-1 != -25):
			neighbours.append([Vector3(x, wall_y, z-1), "d"])
	
	return (neighbours)
