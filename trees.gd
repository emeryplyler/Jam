extends MultiMeshInstance3D

#@onready var tree: MeshInstance3D = $"../Tree"
var tree_collider: PackedScene = preload("res://world/decorations/tree_collider.tscn")
#const TREE_COLLIDER = preload("res://world/decorations/tree_collider.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#multimesh = MultiMesh.new()
	#multimesh.transform_format = MultiMesh.TRANSFORM_3D
	#multimesh.mesh = tree.mesh.duplicate()
	#multimesh.instance_count = 500
	for i in range(multimesh.instance_count):
		#var color = multimesh.get_instance_color(i)
		#var mod = randi_range(0, 10)
		#var new_color = color + Color(0, mod, mod)
		#multimesh.set_instance_color(i, new_color)
		#
		var new_collider = tree_collider.instantiate()
		add_child(new_collider)
		var instance_pos = multimesh.get_instance_transform(i).origin
		new_collider.position = Vector3(instance_pos.x, -15, instance_pos.z)
		#print(instance_transform.basis.y)
