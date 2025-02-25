extends Node

@export var parent: Node
@export var blackout: AnimationPlayer
@onready var e: TextureRect = $"../../../UI/E"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if parent.gone:
		e.set_visible(false)
		blackout.play("blackout")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("res://menu.tscn")
