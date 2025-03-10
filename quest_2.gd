extends Node

@export var photo_cam: Control
@export var quest_manager: Control
@export var quest_base_text: String
var quest_text
var active = false
var need_photos_of = []

var quest_progress = 0
var quest_total_progress = 4

signal dark_picture_quest_begin
signal dark_picture_quest_done

# Called when the node enters the scene tree for the first time.
func prepQuest():
	need_photos_of = ["Bunsie", "Ribberette", "Clawde", "Kittevieve"]
	photo_cam.has_photo_taken.connect(photo_taken)
	active = true
	update_text()
	quest_manager.updateText(quest_text)
	quest_manager.questUIVis(true)
	dark_picture_quest_begin.emit()
	

# listens for signal emitted by camera, logs character in range
func photo_taken(character):
	if active:
		if character in need_photos_of:
			need_photos_of.erase(character)
			quest_progress += 1
			update_text()
			quest_manager.updateText(quest_text)
		if quest_progress >= quest_total_progress:
			quest_manager.questUIVis(false)
			quest_manager.nextQuest()
			active = false
			dark_picture_quest_done.emit()
			
func update_text():
	quest_text = quest_base_text + " " + str(quest_progress) + "/" + str(quest_total_progress)
