extends Node2D

var block_height = 2000 #px block height
var block_width = 2000 #px block width

var stack_length_min = 20 #min length of stacks in blocks
var stack_length_max = 30 #max length of stacks in blocks 
var stack_length

var stack_count_min = 5 # min number of horizontal lines
var stack_count_max = 7 # max number of horizontal lines
var stack_count

var vertical_lines_count_max = 5 # max number of vertical lines
var vertical_lines_count_min = 7 # min number of vertical lines
var vertical_lines_count 

var big_matrix #matrix of values which will spawn the level lines
# 0 empty space (first variant)
# 1 brick (first variant)
# 2 enemy spawner
# 3 player spawn
# 4 boss exit
# 10 exit port
# 11 brick (second variant)
# 12 exit port with enemy
# 20 empty space (second variant)

var count = 0





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_stack_length()
	_set_stack_count()
	_generate_horizontal_lines()
	_generate_vertical_lines()
	
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
							stack[i][j] = 3
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
		
#set vertical line count
func _set_vertical_lines_count():
	vertical_lines_count = randi () % (vertical_lines_count_max - vertical_lines_count_min) + vertical_lines_count_min

func _generate_vertical_lines():
	# generate random verticals
	for i in range(big_matrix.size()-1):
		for j in range(big_matrix[0].size()-1):
			if big_matrix[i][j] == 0 or 2 and i+2 < big_matrix.size():
				var option = randi() % 20
				match option:
					0:
						break
					1:
						big_matrix[i-1][j] = 10
						
	while count < stack_length:
		for i in range(big_matrix.size()-1):
			for j in range(big_matrix[0].size()-1):
				if big_matrix[i][j] == 10:
					big_matrix[i][j] = 0
					var noitop = randi() % 5
					match noitop:
						0:
							#straight down
							big_matrix[i-1][j] = 10
							
						1:
							#to the left
							if j-1 > 0:
								big_matrix[i-1][j] = 0
								big_matrix[i-1][j-1] = 10
							else:
								pass
							
						2:
							#to the right
							if j+1 < big_matrix[0].size()-1:
								big_matrix[i-1][j] = 0
								big_matrix[i-1][j+1] = 10
							else:
								pass
						3:
							#to the left with enemy
							if j-1 > 0:
								big_matrix[i-1][j] = 2
								big_matrix[i-1][j-1] = 10
							else:
								pass
						4: 
							#to the right with enemy
							if j+1 < big_matrix[0].size()-1:
								big_matrix[i-1][j] = 2
								big_matrix[i-1][j+1] = 10
							else:
								pass
						
							
		count += 1
		
		# generate certain vertical
