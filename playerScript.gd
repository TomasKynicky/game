extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DASH_SPEED = 900.0
const LIFE = true
var dashing = false
var can_dash = true

func _physics_process(delta: float) -> void:

	# IS GROUNDED
	if not is_on_floor():
		velocity += get_gravity() * delta

	# DASH 
	dash()
	
	# Print remaining time for next dash
	if not can_dash:
		var time_left = $dash_again_timer.time_left
		print("Time left for next dash: ", round(time_left))

	# JUMP
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		print("WANT JUMP")
		velocity.y = JUMP_VELOCITY

	# EASY MOVE
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		if dashing:
			velocity.x = direction * DASH_SPEED
			dashing = true
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x  = move_toward(velocity.x, 0, SPEED)

	attack_enemy()
	move_and_slide()

func _on_dash_timer_timeout() -> void:
	dashing = false

func _on_dash_again_timer_timeout() -> void:
	can_dash = true
	
func attack_enemy():
	if Input.is_action_just_pressed("ui_space"):
		print("Attack")
		
func dash():
	if Input.is_action_just_pressed("ui_e") and can_dash:
		dashing = true
		can_dash = false
		$dash_timer.start()
		$dash_again_timer.start()
