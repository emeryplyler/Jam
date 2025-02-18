extends Node

@export var quest_base_text: String

var quest_text
var active = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	quest_text = quest_base_text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
