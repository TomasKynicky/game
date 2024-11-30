extends Area2D
var enter_danger_zone: bool = false
@export var boomTime: Timer
var boomStart: bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boomTime.start()
	boomStart = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(boomStart)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	pass # Replace with function body.


func _on_booom_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		enter_danger_zone = true
	else:
		enter_danger_zone = false
		


func _on_boom_time_timeout() -> void:
	boomStart = false
	
