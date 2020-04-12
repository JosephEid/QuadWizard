extends GridMap


# Declare member variables here
onready var player = get_node("/root/Game/Player")
onready var goal = get_node("../Goal")
var rand = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	clear()
	#Plot a grid of cells seperated by walls
	for x in range(-25, 26, 2):
		for z in range (-25, 26):
			set_cell_item(x,0,z,0)
	for z in range(-25, 26, 2):
		for x in range (-25, 26):
			set_cell_item(x,0,z,0)
	rand.randomize()
	var rand_x = rand.randi_range(-12, 12) * 2
	var rand_z = rand.randi_range(-12, 12) * 2
	var starting_cell = Vector3(rand_x, 0, rand_z)
	
	#Start a randomized prim's algorithm to generate paths through the walls
	prims_algorithm(starting_cell)
	
	for x in range(-24, 26, 2):
		for z in range(-24, 26, 2):
			if (get_surrounding_walls(Vector3(x, 0, z)).size() == 3):
				rand.randomize()
				var rand_number = rand.randi_range(0, 100)
				if (rand_number <= 5):
					set_cell_item(x, 0, z, 1)
	
	rand.randomize()
	var goal_x = rand.randi_range(-12, 12) * 2
	var goal_z = rand.randi_range(-12, 12) * 2
	var get_goal_coords = map_to_world(goal_x, 0, goal_z)
	goal.global_transform.origin = Vector3(get_goal_coords.x, get_goal_coords.y, get_goal_coords.z)
	print (goal.global_transform.origin)

			
func prims_algorithm(starting_cell) -> void:
	#Initialize start by selecting a random starting cell.
	var wall_list = []
	print (starting_cell)
	var starting_cell_walls = get_surrounding_walls(starting_cell)
	var get_coords = map_to_world(starting_cell.x, 0, starting_cell.z)
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
			var cell_walls = get_surrounding_walls(adj_cells[1])
			for i in range(len(cell_walls)):
				wall_list.append(cell_walls[i])
			set_cell_item(wall_coords.x, wall_coords.y, wall_coords.z, -1)
		elif (visited_cells.has(adj_cells[1]) && !visited_cells.has(adj_cells[0])):
			visited_cells.append(adj_cells[0])
			var cell_walls = get_surrounding_walls(adj_cells[0])
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
		return [Vector3(x-1, 0, z), Vector3(x+1, 0, z)]
	else:
		return [Vector3(x, 0, z-1), Vector3(x, 0, z+1)]
	
func get_surrounding_walls(cell):
	var x = cell[0]
	var z = cell[2]
	var neighbours = []
	if (get_cell_item(x+1, 0, z) == 0):
		if (x+1 != 25):
			neighbours.append([Vector3(x+1, 0, z), "r"])
	if (get_cell_item(x-1, 0, z) == 0):
		if (x-1 != -25):
			neighbours.append([Vector3(x-1, 0, z), "l"])
	if (get_cell_item(x, 0, z+1) == 0):
		if (z+1 != 25):
			neighbours.append([Vector3(x, 0, z+1), "u"])
	if (get_cell_item(x, 0, z-1) == 0):
		if (z-1 != -25):
			neighbours.append([Vector3(x, 0, z-1), "d"])
	
	return (neighbours)
