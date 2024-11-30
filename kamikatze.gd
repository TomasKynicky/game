extends CharacterBody2D

@export var speed: float = 300.0
@export var player: CharacterBody2D 

var enter_area: bool = false
var target_direction: Vector2 = Vector2.ZERO
var target_locked: bool = false 

func _physics_process(delta: float) -> void:
	if target_locked:
		velocity.x = target_direction.x * speed
		move_and_slide()

	if not is_on_floor():
		velocity += get_gravity() * delta

func _on_player_find_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not target_locked:
		target_direction = (body.position - position).normalized()
		target_locked = true
