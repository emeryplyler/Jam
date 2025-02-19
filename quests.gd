extends Control

#@onready var quest_ui = get_node("QuestText")
#@onready var quest_ui: RichTextLabel = $QuestText
@export var quest_ui: RichTextLabel
@export var quest0: Node
@export var quest1: Node
@export var quest2: Node
@export var quest3: Node
var current_quest
var current_quest_num = 0

enum gameStatus {
	beginning,
	middle,
	end
}

var gameStage: gameStatus

var quests = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameStage = gameStatus.beginning
	quests = [quest0, quest1, quest2, quest3]
	#current_quest = quests[current_quest_num]
	#current_quest.active = true
	#updateText(current_quest.quest_text)

func nextQuest():
	current_quest_num += 1
	#current_quest.active = false # deactivate finished quest
	current_quest = quests[current_quest_num]
	#current_quest.active = true # activate new quest
	#questUIVis(true)
	if current_quest_num == 2:
		gameStage = gameStatus.middle
	elif current_quest_num == 3:
		gameStage = gameStatus.end

func updateText(text):
	quest_ui.text = text
	
func questUIVis(yes):
	quest_ui.set_visible(yes)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if current_quest.quest_finished():
		#nextQuest()
	
