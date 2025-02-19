extends Node
# this one connects howl to the quest system

@export var howl_npc: CharacterBody3D
@export var dialogue_manager: Node
@export var quests: Control

var tutorial = false
var tutorialNode

var post_tutorial = false

var pictures_quest_started = false
var pictures_quest

# Activates quests as howl speaks
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#pass # Replace with function body.
	dialogue_manager.npc_talking.connect(check_lines)
	tutorialNode = quests.get_node("Tutorial")
	tutorialNode.tutorial_done.connect(tutorial_done)
	pictures_quest = quests.get_node("Quest1")

func check_lines(char_name, block, line):
	if char_name == "Howl":
		print("Perceived: %s %d %d %s" % [char_name, block, line, post_tutorial])
		if block == 0 and not tutorial:
			if line == 8:
				tutorialNode.prepQuest()
				tutorial = true
		if block == 2 and not pictures_quest_started:
			pictures_quest_started = true
			pictures_quest.prepQuest()
		


func tutorial_done():
	howl_npc.next_block()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
