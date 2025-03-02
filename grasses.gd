extends MultiMeshInstance3D

@export var pond: Node3D
var pond_pos
const pond_radius = 6.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#pass # Replace with function body.
	pond_pos = pond.global_position
	for i in range(multimesh.instance_count):
		var instance = multimesh.get_instance_transform(i) # hope this is global
		var instance_pos = instance.origin
		if pond_dist(instance_pos.x, instance_pos.z):
			var new_transform = Transform3D(instance.basis * 0, instance.origin)
			multimesh.set_instance_transform(i, new_transform)
			print("set position of mesh number ", i)

func pond_dist(x, y):
	var dist = sqrt(pow((pond_pos.x - x), 2) + pow((pond_pos.y - y), 2))
	return dist <= 6.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
