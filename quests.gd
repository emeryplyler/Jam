extends Control

#@onready var quest_ui = get_node("QuestText")
#@onready var quest_ui: RichTextLabel = $QuestText
@export var quest_ui: RichTextLabel
@export var quest0: Node
@export var quest1: Node
@export var quest2: Node

@export var blackout_overlay: AnimationPlayer
@export var end_timer: Timer
@export var player: CharacterBody3D
@export var player_end_spot: Node3D

var current_quest
var current_quest_num = 0
var moved = false

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
	quests = [quest0, quest1, quest2]
	quest_ui.text = ""
	#current_quest = quests[current_quest_num]
	#current_quest.active = true
	#updateText(current_quest.quest_text)

func nextQuest():
	current_quest_num += 1
	if current_quest_num == 2:
		gameStage = gameStatus.middle
	elif current_quest_num == 3:
		gameStage = gameStatus.end
		end_timer.start() # count down to knocking out the player
		return
	current_quest = quests[current_quest_num]
	#current_quest.active = true # activate new quest
	#questUIVis(true)

func updateText(text):
	quest_ui.text = text
	
func questUIVis(yes):
	quest_ui.set_visible(yes)


func _on_timer_timeout() -> void:
	if not moved:
		blackout_overlay.play("blackout")
		await blackout_overlay.animation_finished
		player.teleport(player_end_spot.to_global(player_end_spot.position))
		player.captured = true
		await get_tree().create_timer(2.0).timeout
		blackout_overlay.play("blackout", -1, -1.0)
		#wake_up()
		moved = true
