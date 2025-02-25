extends Control


@onready var fade_in: AnimationPlayer = $FadeIn/AnimationPlayer

func _ready() -> void:
	fade_in.play("fadein")
	


func _on_start_button_up() -> void:
	get_tree().change_scene_to_file("res://main.tscn")


func _on_settings_button_up() -> void:
	pass # Replace with function body.


func _on_quit_button_up() -> void:
	get_tree().quit()
