extends CharacterBody2D

var speed = 200
@export var player: CharacterBody2D
signal un_life_player

func _physics_process(delta: float) -> void:
	var player_pos = player.position
	var target_pos = (player_pos - position).normalized()
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	
	if position.distance_to(player_pos) > 3:
		velocity.x = target_pos["x"] * speed
		move_and_slide()
		look_at(player_pos)


func _on_un_life_player_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		emit_signal("un_life_player")

func _on_player_un_life_enemy() -> void:
	queue_free()
