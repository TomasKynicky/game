extends Node2D

@export var block_height = 850 #px block height
@export var block_width = 850 #px block width
@export var block_scale = 0.2

@export var stack_length_min = 8 #min length of stacks in blocks
@export var stack_length_max = 10 #max length of stacks in blocks 
var stack_length

@export var stack_count_min = 2 # min number of horizontal lines
@export var stack_count_max = 3 # max number of horizontal lines
var stack_count

@export var vertical_lines_count_max = 4 # max number of vertical lines
@export var vertical_lines_count_min = 5 # min number of vertical lines
var vertical_lines_count 

@export var vertical_probability = 2

var big_matrix #matrix of values which will spawn the level lines
# 0 empty space (first variant)
# 1 brick (first variant)
# 2 enemy spawner (kamikaze)
# 3 player spawn 
# 4 boss exit
# 5 granadier spawner
# 6 sniper spawner
# 10 exit port
# 11 brick (second variant)
# 12 exit port with enemy
# 20 empty space (second variant)

var count = 0

var empty1 = preload("res://empty1.tscn")
var empty2 = preload("res://empty2.tscn")
var brick1 = preload("res://brick1.tscn")
var brick2 = preload("res://brick2.tscn")
var player_spawn = preload("res://player_spawn.tscn")
var player_exit = preload("res://player_exit.tscn")
var kamikaze_spawn = preload("res://kamikaze_spawn.tscn")
var grenadier_spawn = preload("res://grenadier_spawn.tscn")
var sniper_spawn = preload("res://sniper_spawn.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_stack_length()
	_set_stack_count()
	_generate_horizontal_lines()
	big_matrix = _remove_10(big_matrix)
	_generate_vertical_lines()
	big_matrix = _remove_10(big_matrix)
	_randomize_bricks()
	_randomize_emptys()
	_randomize_enemies()
	_add_spawn()
	_add_exit()
	_instantiate_shit()
	
	for i in range(big_matrix.size()):
		print(big_matrix[i])

#set length of stacks in blocks
func _set_stack_length():
	stack_length = randi() % (stack_length_max - stack_length_min) + stack_length_min
	
#set number of stacks
func _set_stack_count():
	stack_count = randi () % (stack_count_max - stack_count_min) + stack_count_min
	
#generate square matrix 
func _generate_square_matrix(size,val):
	var stack = []
	for i in range(size):
		stack.append([])
		for j in range(size):
			stack[i].append(val)
	return stack
			
	#fill matrix
	
#generate horizontal line, a stack if you will
func _generate_stack():
	#generate matrix && make it shit bricks
	var stack = _generate_square_matrix(stack_length, 1)
	#make spawn
	stack[1][0] = 0 
	stack[1][1] = 10
	#make path
	#for each column
	for j in range(1,stack_length):
		#in each line
		for i in range(1,stack[j].size()):
		#check wether on your left is exit port
			if stack[i][j-1] == 10:
				stack[i][j-1] = 0
				var option = randi() % 6
				match option:
					0:
						#continue straight
						stack[i][j] = 10
					1:
						if i < stack[j].size():
							#continue down
							stack[i][j] = 0
							stack[i+1][j] = 10
						else:
							stack[i][j] = 10
					2: 
						if i > 1:
							#continue up
							stack[i][j] = 0
							stack[i-1][j] = 10
						else:
							stack[i][j] = 10
						
					3:
						#continue down with enemy
						if i < stack[j].size():
							#continue down
							stack[i][j] = 0
							stack[i+1][j] = 12
						else:
							stack[i][j] = 10
					4: 
						#continue up with enemy
						if i > 1:
							#continue up
							stack[i][j] = 2
							stack[i-1][j] = 10
						else:
							stack[i][j] = 10
						
					5: 
						#continue straight with enemy
						stack[i][j] = 12
						
			if stack[i][j-1] == 12:
				stack[i][j-1] = 2
				var option = randi() % 6
				match option:
					0:
						#continue straight
						stack[i][j] = 10
					1:
						if i < stack[j].size():
							#continue down
							stack[i][j] = 0
							stack[i+1][j] = 10
						else:
							stack[i][j] = 10
					2: 
						if i > 1:
							#continue up
							stack[i][j] = 0
							stack[i-1][j] = 10
						else:
							stack[i][j] = 10
						
					3:
						#continue down with enemy
						if i < stack[j].size():
							#continue down
							stack[i][j] = 0
							stack[i+1][j] = 12
						else:
							stack[i][j] = 10
					4: 
						#continue up with enemy
						if i > 1:
							#continue up
							stack[i][j] = 2
							stack[i-1][j] = 10
						else:
							stack[i][j] = 10
						
					5: 
						#continue straight with enemy
						stack[i][j] = 12
						
	stack = _crop_stack(stack)
	return stack
	#for i in stack.size():
		#print(stack[i])
	
# crop stack used in generate stack
func _crop_stack(stack):
	var crop = 0
	for i in range(0,stack_length):
		var flag = true
		for j in range(0,stack_length):
			if stack[i][j] != 1:
				flag = false
		if flag: 
			crop += 1
			
	#assign to matrix
	var matrix = []
	for i in range(0, stack_length - crop+1):
		matrix.append([])
		for j in range(0, stack_length):
			matrix[i].append(stack[i][j])
			
	var wall = []
	for i in range(stack_length):
		wall.append(1)
		
	matrix.append(wall)
			
		
	return matrix
		
# put stacks atop of each other
func _generate_horizontal_lines():
	var matrix = []
	for x in range(stack_count):
		var stack = _generate_stack()
		#for z in range(stack.size()):
			#print(stack[z])
		matrix.append_array(stack)

	big_matrix = matrix
	#for i in range(matrix.size()):
		#print(matrix[i])

func _remove_10(matrix):
	for i in range(matrix.size()):
		for j in range(matrix[0].size()):
			if matrix[i][j] == 10 or matrix[i][j] == 12 :
				matrix[i][j] = 0
	return matrix
		
#set vertical line count
func _set_vertical_lines_count():
	vertical_lines_count = randi () % (vertical_lines_count_max - vertical_lines_count_min) + vertical_lines_count_min

#generate vertical lines
func _generate_vertical_lines():
	
	# generate random verticals
	for i in range(big_matrix.size()-2):
		for j in range(big_matrix[0].size()):
			if big_matrix[i][j] == 0 or big_matrix[i][j] == 2:
				var option = randi() % vertical_probability
				match option:
					1:
						big_matrix[i+1][j] = 10
					_:
						break
						
	while count < stack_length:
		for i in range(big_matrix.size()-2):
			for j in range(big_matrix[0].size()-1):
				if big_matrix[i][j] == 10:
					big_matrix[i][j] = 0
					var noitop = randi() % 5
					match noitop:
						0:
							#straight down
							big_matrix[i+1][j] = 10
							
						1:
							#to the left
							if j-1 > 0:
								big_matrix[i+1][j] = 0
								big_matrix[i+1][j-1] = 10
							else:
								pass
							
						2:
							#to the right
							if j+1 < big_matrix[0].size()-1:
								big_matrix[i+1][j] = 0
								big_matrix[i+1][j+1] = 10
							else:
								pass
						3:
							#to the left with enemy
							if j-1 > 0:
								big_matrix[i+1][j] = 2
								big_matrix[i+1][j-1] = 10
							else:
								pass
						4: 
							#to the right with enemy
							if j+1 < big_matrix[0].size()-1:
								big_matrix[i+1][j] = 2
								big_matrix[i+1][j+1] = 10
							else:
								pass
						
							
		count += 1
		
		# generate certain vertical
		#no >:/

#randomize bricks
func _randomize_bricks():
	for i in range(big_matrix.size()):
		for j in range(big_matrix[0].size()):
			if big_matrix[i][j] == 1:
				var option = randi() % 2
				match option:
					1:
						big_matrix[i][j] = 11
					_:
						pass
	
#randomize emptys
func _randomize_emptys():
	for i in range(big_matrix.size()):
		for j in range(big_matrix[0].size()):
			if big_matrix[i][j] == 0:
				var option = randi() % 2
				match option:
					1:
						big_matrix[i][j] = 20
					_:
						pass

#randomize enemies
func _randomize_enemies():
	for i in range(big_matrix.size()):
		for j in range(big_matrix[0].size()):
			if big_matrix[i][j] == 2:
				var option = randi() % 3
				match option:
					1:
						big_matrix[i][j] = 5
					2:
						big_matrix[i][j] = 6
					_:
						pass

#add spawn
func _add_spawn():
	var j = 0
	for i in range(big_matrix.size()):
		if big_matrix[i][j] == 0 or big_matrix[i][j] == 20:
			big_matrix[i][j] = 1
	big_matrix[1][0] = 3
				
#add exit
func _add_exit():
	var safei
	var j = big_matrix[0].size()-1
	for i in range(big_matrix.size()):
		if big_matrix[i][j] == 0 or big_matrix[i][j] == 20:
			safei = i
			big_matrix[i][j] = 1
	big_matrix[safei][j] = 4	

#instantiate shit
func _instantiate_shit():
	for i in range(big_matrix.size()):
		for j in range(big_matrix[0].size()):
			var option = big_matrix[i][j]
			match option:
				0:
					var empty1_instance = empty1.instantiate()
					add_child(empty1_instance)
					var child_count = self.get_child_count()
					var children = self.get_children()
					var child = children[child_count-1]
					child.position = Vector2((block_width*block_scale)/2+j*(block_width)*block_scale,(block_height*block_scale)/2+i*block_height*block_scale)
					child.scale = Vector2(block_scale,block_scale)
				20:
					var empty2_instance = empty2.instantiate()
					add_child(empty2_instance)
					var child_count = self.get_child_count()
					var children = self.get_children()
					var child = children[child_count-1]
					child.position = Vector2((block_width*block_scale)/2+j*(block_width)*block_scale,(block_height*block_scale)/2+i*block_height*block_scale)
					child.scale = Vector2(block_scale,block_scale)
				1:
					var brick1_instance = brick1.instantiate()
					add_child(brick1_instance)
					var child_count = self.get_child_count()
					var children = self.get_children()
					var child = children[child_count-1]
					child.position = Vector2((block_width*block_scale)/2+j*(block_width)*block_scale,(block_height*block_scale)/2+i*block_height*block_scale)
					child.scale = Vector2(block_scale,block_scale)
				11:
					var brick2_instance = brick2.instantiate()
					add_child(brick2_instance)
					var child_count = self.get_child_count()
					var children = self.get_children()
					var child = children[child_count-1]
					child.position = Vector2((block_width*block_scale)/2+j*(block_width)*block_scale,(block_height*block_scale)/2+i*block_height*block_scale)
					child.scale = Vector2(block_scale,block_scale)
				3:
					var player_spawn_instance = player_spawn.instantiate()
					add_child(player_spawn_instance)
					var child_count = self.get_child_count()
					var children = self.get_children()
					var child = children[child_count-1]
					child.position = Vector2((block_width*block_scale)/2+j*(block_width)*block_scale,(block_height*block_scale)/2+i*block_height*block_scale)
					child.scale = Vector2(block_scale,block_scale)
				4:
					var player_exit_instance = player_exit.instantiate()
					add_child(player_exit_instance)
					var child_count = self.get_child_count()
					var children = self.get_children()
					var child = children[child_count-1]
					child.position = Vector2((block_width*block_scale)/2+j*(block_width)*block_scale,(block_height*block_scale)/2+i*block_height*block_scale)
					child.scale = Vector2(block_scale,block_scale)
				2:
					var kamikaze_spawn_instance = kamikaze_spawn.instantiate()
					add_child(kamikaze_spawn_instance)
					var child_count = self.get_child_count()
					var children = self.get_children()
					var child = children[child_count-1]
					child.position = Vector2((block_width*block_scale)/2+j*(block_width)*block_scale,(block_height*block_scale)/2+i*block_height*block_scale)
					child.scale = Vector2(block_scale,block_scale)
				5:
					var grenadier_spawn_instance = grenadier_spawn.instantiate()
					add_child(grenadier_spawn_instance)
					var child_count = self.get_child_count()
					var children = self.get_children()
					var child = children[child_count-1]
					child.position = Vector2((block_width*block_scale)/2+j*(block_width)*block_scale,(block_height*block_scale)/2+i*block_height*block_scale)
					child.scale = Vector2(block_scale,block_scale)
				6:
					var sniper_spawn_instance = sniper_spawn.instantiate()
					add_child(sniper_spawn_instance)
					var child_count = self.get_child_count()
					var children = self.get_children()
					var child = children[child_count-1]
					child.position = Vector2((block_width*block_scale)/2+j*(block_width)*block_scale,(block_height*block_scale)/2+i*block_height*block_scale)
					child.scale = Vector2(block_scale,block_scale)
				_:
					break
