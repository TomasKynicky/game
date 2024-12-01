extends RigidBody2D

var enter_danger_zone: bool = false
@export var boomTime: Timer
@export var timeOfBooom: Timer
@export var SPEED = 6
var boomStart: bool
var dir: float
var spawnPos: Vector2
var spawnRot: float

signal un_life_player

func _ready() -> void:
	global_position = spawnPos
	global_rotation = spawnRot
	boomTime.start()

func _process(delta: float) -> void:
	print(boomStart)
	if boomStart == true and enter_danger_zone == true: 
		emit_signal("un_life_player")

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	pass # Replace with function body.


func _on_booom_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		enter_danger_zone = true
	else:
		enter_danger_zone = false
		


func _on_boom_time_timeout() -> void:
	boomStart = true
	timeOfBooom.start()
	


func _on_time_of_booom_timeout() -> void:
	boomStart = false
	queue_free()
