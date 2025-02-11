extends CharacterBody3D

@export var character_name: String

var ui: Control # interaction icon
var dialogue_manager: Control # this is for sending signals to the dialogue script
var dialogue_script: Control # this is for getting the number of lines
var line_number: int # index of line that the character has just said
var num_of_lines: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui = get_tree().root.get_node("Root/UI/E")
	dialogue_manager = get_tree().root.get_node("Root/UI/DialogueManager")
	dialogue_script = get_tree().root.get_node("Root/UI/Dialogue")
	line_number = -1
	num_of_lines = dialogue_script.get_num_of_lines(character_name)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func highlight():
	ui.set_visible(true)
	ui.get_node("Chat").set_visible(true)
	

func unhighlight():
	ui.set_visible(false)
	ui.get_node("Chat").set_visible(false)

# is called whenever the player interacts with npc
# returns whether npc is still talking for the player script
func on_interact():
	if line_number < num_of_lines - 1:
		line_number += 1
		dialogue_manager.npc_talking.emit(character_name, line_number)
		return true
	else:
		stop_talking()
		return false

# called by player when the npc first starts talking
func start_talking():
	dialogue_script.start_dialogue()
	on_interact()


func stop_talking():
	dialogue_script.finish_dialogue()
