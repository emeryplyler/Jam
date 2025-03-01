extends Node

@export var parent: Node
@export var blackout: AnimationPlayer
@onready var e: TextureRect = $"../../../UI/E"
@export var howl_animator: AnimationPlayer
@export var howl_sprite: Sprite3D

# special howl faces
@export var faces: Array[Texture2D]

var ending = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if parent.line_number == 3:
		# deactivate animation
		howl_animator.stop()
		howl_sprite.set_texture(faces[1])
	elif parent.line_number == 4:
		howl_sprite.set_texture(faces[2]) # angry
	elif parent.line_number == 6:
		howl_sprite.set_texture(faces[0]) # sly face
	elif parent.line_number == 15:
		howl_sprite.set_texture(faces[4]) # taking picture
	
	if parent.gone and not ending:
		ending = true
		e.set_visible(false)
		howl_sprite.set_texture(faces[3])
		blackout.play("blackout")
		await get_tree().create_timer(3.0).timeout
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene_to_file("res://menu.tscn")
	
	if ending:
		if blackout.current_animation_position > 0.3:
			blackout.pause()
