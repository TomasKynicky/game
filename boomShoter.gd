extends CharacterBody2D

@onready var grenade = preload("res://Granade.tscn") # Ensure Granade.tscn is set up correctly.
@export var rayCastRight: RayCast2D
@export var rayCastLeft: RayCast2D
@export var timer: Timer
@export var player: CharacterBody2D
var danger_zone: bool = false

func _ready() -> void:
	# Start the timer to trigger grenade shooting
	timer.start()
	# Ensure the timer is connected to the function
	timer.timeout.connect(_on_bomboclattime_timeout)

func shoot() -> void:
	# Spawn and configure the grenade
	var position_player = player.global_position
	var instance = grenade.instantiate()
	
	# Calculate spawn position slightly offset from machine
	instance.global_positon = position_player + Vector2(0, -10)
	
	# Calculate direction towards the player
	var direction = (player.global_position - global_position).normalized()
	instance.direction = direction  # Assuming grenade has a direction variable
	
	# Add the grenade to the scene
	get_parent().add_child(instance)

func _physics_process(delta: float) -> void:
	# Update danger_zone based on raycasts
	if rayCastLeft.is_colliding() and rayCastLeft.get_collider().is_in_group("player"):
		danger_zone = true
	elif rayCastRight.is_colliding() and rayCastRight.get_collider().is_in_group("player"):
		danger_zone = true
	else:
		danger_zone = false

func _on_bomboclattime_timeout() -> void:
	# Shoot if player is in the danger zone
	if danger_zone:
		shoot()
