extends CharacterBody2D

@export var speed: float = 300.0
@export var player: CharacterBody2D 
@export var rayCastRight: RayCast2D
@export var rayCastLeft: RayCast2D

var enter_area: bool = false
var target_direction: Vector2 = Vector2.ZERO
var target_locked: bool = false 
signal un_life_player
var enter_danger_area: bool = false


func _physics_process(delta: float) -> void:
	if target_locked:
		velocity.x = target_direction.x * speed
		move_and_slide()

	if not is_on_floor():
		velocity += get_gravity() * delta

	# Check if any of the raycasts are colliding
	if rayCastRight.is_colliding():
		var collider = rayCastRight.get_collider()
		var collideObject = str(collider.get_groups())
		if collideObject == '[&"player"]':
			emit_signal("un_life_player")
		if enter_danger_area == true:
			emit_signal("un_life_player")
		queue_free()
	if rayCastLeft.is_colliding():
		var collider = rayCastLeft.get_collider()
		var collideObject = str(collider.get_groups())
		if collideObject == '[&"player"]':
			emit_signal("un_life_player")
		if enter_danger_area == true:
			emit_signal("un_life_player")
		queue_free()
	

func _on_player_find_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not target_locked:
		target_direction = (body.position - position).normalized()
		target_locked = true


func _on_danger_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		enter_danger_area = true
	else:
		enter_danger_area = false
