extends Sprite3D

@export var deathsprite: Texture2D
@export var ribberette: CharacterBody3D
var gone = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not gone:
		var ribberette_texture = ribberette.get_node("Sprite3D").texture
		if ribberette_texture == ribberette.deathsprite and ribberette.visible:
		#if ribberette.gone:
			#ribberette.get_node("Sprite3D").set_modulate(Color(1, 1, 1, 0))
			#set_texture(deathsprite)
			set_visible(false)
			gone = true
