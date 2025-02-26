extends MultiMeshInstance3D

@onready var tree: MeshInstance3D = $"../Tree"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#multimesh = MultiMesh.new()
	#multimesh.transform_format = MultiMesh.TRANSFORM_3D
	#multimesh.mesh = tree.mesh.duplicate()
	for i in range(multimesh.instance_count):
		var color = multimesh.get_instance_color(i)
		var mod = randi_range(0, 10)
		var new_color = color + Color(0, mod, mod)
		multimesh.set_instance_color(i, new_color)
		
		var instance_transform: Transform3D = multimesh.get_instance_transform(i)
		print(instance_transform.basis.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
