extends Control
@export var audio : AudioStreamPlayer2D
var game = preload("res://background.tscn") #insert name of main scene here

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_retry_button_down() -> void:
	get_tree().change_scene_to_file(game)


func _on_quit_button_down() -> void:
	get_tree().quit()
