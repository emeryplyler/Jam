extends AudioStreamPlayer

const YANSIM = preload("res://music/yansim.ogg")
const YANSIM_CORPSEVILLAGE = preload("res://music/yansim_corpsevillage.ogg")

@onready var quest: Node = $"../UI/Quests/Quest2"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play()
	quest.dark_picture_quest_begin.connect(onStageChange)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func onStageChange():
	var pos = get_playback_position()
	set_stream(YANSIM_CORPSEVILLAGE)
	play(pos)


func _on_timer_timeout() -> void:
	stop()
