extends CharacterBody3D

@export var character_name: String

var ui: Control # interaction icon
var dialogue_manager: Control # this is for sending signals to the dialogue script
var dialogue_script: Control # this is for getting the number of lines
var block_number: int
var line_number: int # index of line that the character has just said
var num_of_lines: int
var usingRandomBlock = false
var midGame = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui = get_tree().root.get_node("Root/UI/E")
	dialogue_manager = get_tree().root.get_node("Root/UI/DialogueManager")
	dialogue_script = get_tree().root.get_node("Root/UI/Dialogue")
	block_number = 0
	line_number = -1
	num_of_lines = dialogue_script.get_num_of_lines(character_name, block_number)


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
	if usingRandomBlock and line_number == -1:
		if not midGame:
			random_block(2, 4)
	if block_number >= 6 and block_number <= 8 and line_number < num_of_lines - 1:
		random_block(6, 8)
	if line_number < num_of_lines - 1:
		line_number += 1
		dialogue_manager.npc_talking.emit(character_name, block_number, line_number)
		return true
	else:
		if block_number == 1 and line_number == 2: # ok not proud of this ngl
			next_block()
			stop_talking()
			line_number += 1
			return false
		if block_number == 5 and line_number == 7:
			set_block(8)
			stop_talking()
			line_number += 1
			return false
		else:
			stop_talking()
			return false

# called by player when the npc first starts talking
func start_talking():
	dialogue_script.start_dialogue()
	on_interact()


func stop_talking():
	dialogue_script.finish_dialogue()
	line_number -= 1 # reset line number to the last line character said

# is called when signal emitted allowing continue
# for howl this is connected to quest system
func next_block():
	block_number += 1 # finished this current block, go to next one
	num_of_lines = dialogue_script.get_num_of_lines(character_name, block_number)
	line_number = -1 # reset line num

func set_block(block_index):
	block_number = block_index
	num_of_lines = dialogue_script.get_num_of_lines(character_name, block_number)
	line_number = -1

func random_block(rangeMin, rangeMax):
	#block_number = randi_range(rangeMin, rangeMax)
	block_number += 1
	if block_number > rangeMax:
		block_number = rangeMin
	line_number = -1
	num_of_lines = dialogue_script.get_num_of_lines(character_name, block_number)
