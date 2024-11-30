extends CharacterBody2D

@export var target: CharacterBody2D
@export var rayCast: RayCast2D
@export var gunSprite: MeshInstance2D
@export var turetDelay = 0.5
@export var timer: Timer
var target_hit = false
var enter_area = false

signal un_life_player_with_sniper

func _ready():
	target = findTarget()
	
func _physics_process(delta):
	if enter_area and target_hit:
		emit_signal("un_life_player_with_sniper")
		enter_area = false

	if target != null:
		var angle_to_target: float = global_position.direction_to(target.global_position).angle()
		
		if angle_to_target > rayCast.global_rotation:
			rayCast.global_rotation += delta * turetDelay
		if angle_to_target < rayCast.global_rotation:
			rayCast.global_rotation -= delta * turetDelay
	
	 #form_angle(angle_to_target).lerp(form_angle(rayCast.global_rotation), 0.5)
		if rayCast.is_colliding() and rayCast.get_collider().is_in_group("player"):
			gunSprite.rotation = angle_to_target
func shoot():
	target_hit = true 

func findTarget():
	var new_target

	var fake_target = Vector2(0,0)
	if get_tree().has_group("player"):
		new_target = get_tree().get_nodes_in_group("player")[0]
		return new_target


func _on_hit_body_entered(body: Node2D) -> void: 
	if !body.is_in_group("player"):
		enter_area = false
	if body.is_in_group("player"):
		timer.start()
		enter_area = true


func _on_delay_timeout() -> void:
	shoot()


func _on_player_un_life_enemy() -> void:
		queue_free()
