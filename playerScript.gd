extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DASH_SPEED = 900.0
var life = true
var dashing = false
var can_dash = true
var last_move
var enemy_in_area = false
@export var shape_right: CollisionShape2D
@export var shape_left: CollisionShape2D

signal un_life_enemy

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
		

	if direction >= 0:
		last_move = "right"
	elif direction <= 0:
		last_move = "left"
		
	if last_move == "left":
		shape_right.disabled = true
		shape_left.disabled = false
	if last_move == "right":
		shape_left.disabled = true
		shape_right.disabled = false

	
	if Input.is_action_pressed("ui_space") and enemy_in_area:
		emit_signal("un_life_enemy")
		enemy_in_area = false
		

	move_and_slide()

func _on_dash_timer_timeout() -> void:
	dashing = false

func _on_dash_again_timer_timeout() -> void:
	can_dash = true

		
func dash():
	if Input.is_action_just_pressed("ui_e") and can_dash:
		dashing = true
		can_dash = false
		$dash_timer.start()
		$dash_again_timer.start()


func _on_enemy_un_life_player() -> void:
	get_tree().change_scene_to_file("res://game_over.tscn")
	
func _on_do_dmg_body_entered(body: Node2D) -> void:
	if !body.is_in_group("enemy"):
		enemy_in_area = false
	if body.is_in_group("enemy"):#and Input.is_action_pressed("ui_space")
		enemy_in_area = true
