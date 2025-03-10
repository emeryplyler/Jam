extends AudioStreamPlayer

const YANSIM_CORPSEVILLAGE = preload("res://music/yansim_corpsevillage.ogg")
const THUD = preload("res://music/thud.ogg")

var no_music = false

@onready var quest: Node = $"../UI/Quests/Quest2"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(3.0).timeout
	play()
	quest.dark_picture_quest_begin.connect(onStageChange)


func onStageChange():
	var pos = get_playback_position()
	set_stream(YANSIM_CORPSEVILLAGE)
	play(pos)


func _on_timer_timeout() -> void:
	if not no_music:
		#parameters.looping = false
		#"parameters/looping"
		no_music = true
		stop()
		set_stream(THUD)
		play()
