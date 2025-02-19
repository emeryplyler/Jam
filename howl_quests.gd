extends Node

@export var howl_npc: CharacterBody3D
@export var dialogue_manager: Node
@export var quests: Control

var tutorial = false
var tutorialNode

# Activates quests as howl speaks
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#pass # Replace with function body.
	dialogue_manager.npc_talking.connect(check_lines)
	tutorialNode = quests.get_node("Tutorial")
	tutorialNode.tutorial_done.connect(tutorial_done)

func check_lines(char_name, block, line):
	if char_name == "Howl":
		if block == 0 and not tutorial:
			if line == 8:
				tutorialNode.prepQuest()
				tutorial = true
		
		
		

func tutorial_done():
	howl_npc.next_block()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
