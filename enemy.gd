extends CharacterBody2D

var speed = 200
@export var player: CharacterBody2D

func _physics_process(delta: float) -> void:
	var player_pos = player.position
	var target_pos = (player_pos - position).normalized()
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	
	if position.distance_to(player_pos) > 3:
		velocity.x = target_pos["x"] * speed
		move_and_slide()
		look_at(player_pos)
