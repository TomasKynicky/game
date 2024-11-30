extends CharacterBody2D

@export var target: CharacterBody2D
@export var rayCast: RayCast2D
@export var gunSprite: MeshInstance2D
@export var turetDelay = 0.5
@export var timer: Timer
var target_hit = false
var enter_area = false
var max_angle = 1
var min_angle = -180
var stateRotation = TurnState.TURNINGRIGHT

enum TurnState{
	FOLLOWING_PLAYER, TURNINGLEFT, TURNINGRIGHT
}

signal un_life_player_with_sniper

func _ready():
	target = findTarget()
	
func _physics_process(delta):
	var angleGunSprite = gunSprite.rotation_degrees
	if stateRotation == TurnState.FOLLOWING_PLAYER:
		if enter_area and target_hit:
			emit_signal("un_life_player_with_sniper")
			enter_area = false

		if target != null:
			var angle_to_target: float = global_position.direction_to(target.global_position).angle()
			
			if angle_to_target > rayCast.global_rotation:
				rayCast.global_rotation += delta * turetDelay
				gunSprite.rotation += delta * turetDelay
			if angle_to_target < rayCast.global_rotation:
				rayCast.global_rotation -= delta * turetDelay
				gunSprite.rotation -= delta * turetDelay
				
	elif stateRotation == TurnState.TURNINGRIGHT:
		print("-", angleGunSprite)
		rayCast.global_rotation += delta * turetDelay
		gunSprite.rotation += delta * turetDelay
		if angleGunSprite > max_angle:
			stateRotation = TurnState.TURNINGLEFT
	elif stateRotation == TurnState.TURNINGLEFT:
		rayCast.global_rotation -= delta * turetDelay
		gunSprite.rotation -= delta * turetDelay
		if angleGunSprite < min_angle:
			stateRotation = TurnState.TURNINGRIGHT

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


func _on_danger_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		stateRotation = TurnState.FOLLOWING_PLAYER
	


func _on_danger_area_body_exited(body: Node2D) -> void:
	print("Exit")
	if body.is_in_group("player"):
		stateRotation = TurnState.TURNINGRIGHT
