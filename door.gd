extends Area3D

# listen for an interaction signal that will be sent when the player interacts with this item
# when signal is received, teleport player to the decided location
# location must be unique between doors

# match this door name between matching locations
#@export var door_name: String
@export var destination: Area3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# called by player script
func on_interact():
	var target = destination.global_position
	return(target)
