extends Node

@export var photo_cam: Control
@export var quest_manager: Control
@export var quest_base_text: String

var quest_text
var started = false
var active = false

var need_photos_of = []

signal tutorial_done

# Called when the node enters the scene tree for the first time.
func prepQuest():
	need_photos_of = ["Howl"]
	photo_cam.has_photo_taken.connect(photo_taken)
	quest_text = quest_base_text
	active = true
	quest_manager.updateText(quest_text)
	quest_manager.questUIVis(true)

func photo_taken(character):
	if active:
		if character in need_photos_of:
			quest_manager.questUIVis(false) # quest complete
			quest_manager.nextQuest()
			active = false
			tutorial_done.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
