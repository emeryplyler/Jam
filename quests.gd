extends Control

#@onready var quest_ui = get_node("QuestText")
#@onready var quest_ui: RichTextLabel = $QuestText
@export var quest_ui: RichTextLabel
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
	quests = [quest1, quest2, quest3]
	current_quest = quests[current_quest_num]
	print(quests)

func nextQuest():
	current_quest_num += 1
	current_quest = quests[current_quest_num]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if current_quest.quest_finished():
		#nextQuest()
	
