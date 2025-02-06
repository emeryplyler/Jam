extends Area3D

# listen for an interaction signal that will be sent when the player interacts with this item
# when signal is received, teleport player to the decided location
# location must be unique between doors

# match this door name between matching locations
#@export var door_name: String
@export var destination: Area3D
var ui: Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui = get_tree().root.get_node("Root/UI/E")
	print(ui)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# called by player script
func on_interact():
	var target = destination.global_position
	return(target)
	
func highlight():
	ui.set_visible(true)
	ui.get_node("OpenDoor").set_visible(true)
	print("You're looking at", self)
	

func unhighlight():
	print("You stopped looking at", self)
	ui.set_visible(false)
	ui.get_node("OpenDoor").set_visible(false)
