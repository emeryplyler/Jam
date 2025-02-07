extends CharacterBody3D

@export var character_name: String

var ui: Control
var dialogue_manager: Control
var line_number: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui = get_tree().root.get_node("Root/UI/E")
	dialogue_manager = get_tree().root.get_node("Root/UI/DialogueManager")
	line_number = 0


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func highlight():
	ui.set_visible(true)
	ui.get_node("Chat").set_visible(true)
	

func unhighlight():
	ui.set_visible(false)
	ui.get_node("Chat").set_visible(false)


func on_interact():
	dialogue_manager.emit_signal("npc_talking", character_name, line_number)
