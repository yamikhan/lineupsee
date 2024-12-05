@tool
extends Node3D

@export var tree_trunk_scene: PackedScene = preload("res://scenes/treeoak.tscn")
@export var leaf_scene: PackedScene = preload("res://scenes/leaf.tscn")

# Number of trunk blocks
@export var trunk_height: int = 5
# Number of leaf layers (to fill the top two blocks)
@export var leaf_layers: int = 2
# Size of the leaf area around the trunk
@export var leaf_area_size: float = 1.5

func _ready():
	# Get the scale of the trunk from the instantiated scene
	var tree_trunk = tree_trunk_scene.instantiate()
	var trunk_scale = tree_trunk.scale
	
	# Create the tree trunk by instantiating multiple treeoak.tscn blocks
	for i in range(trunk_height):
		var tree_trunk_instance = tree_trunk_scene.instantiate()
		tree_trunk_instance.position = Vector3(0, i * trunk_scale.y, 0)  # Stack trunk blocks on top of each other
		add_child(tree_trunk_instance)

	# Create leaves to fill the top 'leaf_layers' blocks of the trunk
	for i in range(leaf_layers):
		var leaf_height = trunk_height * trunk_scale.y + i * trunk_scale.y  # Position for the current leaf layer
		for x in range(-1, 2):  # Create a 3x3 grid (from -1 to 1)
			for z in range(-1, 2):
				var leaves = leaf_scene.instantiate()
				leaves.position = Vector3(x * trunk_scale.x, leaf_height, z * trunk_scale.z)
				add_child(leaves)
