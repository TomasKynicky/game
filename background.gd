extends Node2D

var block_height = 2000 #px block height
var block_width = 2000 #px block width

var stack_length_min = 5 #min length of stacks in blocks
var stack_length_max = 10 #max length of stacks in blocks 
var stack_length

var stack_count_min = 5 # min number of horizontal paths
var stack_count_max = 7 # max number of horizontal lines
var stack_count

var matrix #matrix of values which will spawn the level
# 0 empty space
# 1 brick
# 2 enemy spawner
# 3 player spawn
# 4 boss exit
# 10 exit port
# 13 exit port with enemy





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_stack_length()
	_set_stack_count()
	_generate_stack()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
	stack[1][0] = 3 
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
	
	for i in stack.size():
		print(stack[i])
	
	
		
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
		

			

		
