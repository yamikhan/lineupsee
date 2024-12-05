@tool
extends Node3D

@export var dirt_scene: PackedScene = preload("res://scenes/dirt.tscn")
@export var grass_scene: PackedScene = preload("res://scenes/grass.tscn")
@export var stone_scene: PackedScene = preload("res://scenes/stone.tscn")
@export var blackstone_scene: PackedScene = preload("res://scenes/blackstone.tscn")
@export var tree_scene: PackedScene = preload("res://scenes/tree.tscn")  # Add the tree scene
@onready var fps_label: Label = $fps_label
@export var levels: int = 10  # Number of layers in the pyramid
@export var cube_size: float = 8.0  # Size of each cube (edge length)

var placed_cubes = {}

func _ready():
	create_connected_pyramid()  # Create the connected pyramid
	place_trees_at_top_corners()  # Place trees at the four corners of the top layer

func create_connected_pyramid():
	var base_size = levels * 2

	for row in range(1, levels + 1):
		var cube_scene: PackedScene = get_scene_for_layer(row)
		var num_cubes = base_size - (row - 1) * 2

		for col_x in range(num_cubes):
			for col_z in range(num_cubes):
				var cube = cube_scene.instantiate()
				add_child(cube)

				# Calculate the position of the cube
				var x = (col_x - int(num_cubes / 2)) * cube_size
				var y = (levels - row) * cube_size
				var z = (col_z - int(num_cubes / 2)) * cube_size

				# Set the cube's position
				cube.transform.origin = Vector3(x, y, z)
				placed_cubes[Vector3(x, y, z)] = cube

# Determine the cube scene to use for the given layer
func get_scene_for_layer(layer: int) -> PackedScene:
	if layer == 1:
		return grass_scene
	elif layer <= 3:
		return dirt_scene
	elif layer <= 6:
		return stone_scene
	else:
		return blackstone_scene

# Place one tree in each corner of the top layer of the pyramid
func place_trees_at_top_corners():
	var top_layer_y = (levels) * cube_size  # Y-coordinate of the top layer
	var half_cube_size = 10 # Half the size of one cube

	# Adjust positions for the corners of a single cube (square top)
	var corner_positions = [
		Vector3(-half_cube_size, top_layer_y, -half_cube_size),  # Top-left corner
		Vector3(half_cube_size-1, top_layer_y, -half_cube_size),   # Top-right corner
		Vector3(-half_cube_size, top_layer_y, half_cube_size-1),   # Bottom-left corner
		Vector3(half_cube_size-1, top_layer_y, half_cube_size-1)     # Bottom-right corner
	]

	# Instantiate trees at the calculated corner positions
	for corner_pos in corner_positions:
		var tree = tree_scene.instantiate()
		tree.transform.origin = corner_pos
		add_child(tree)

func add_fps_counter():
	# Create a new Label node for displaying FPS
	fps_label.text = "FPS: 0"
	fps_label.anchor_left = 0
	fps_label.anchor_top = 0
	fps_label.anchor_right = 0
	fps_label.anchor_bottom = 0
	fps_label.offset_left = 10
	fps_label.offset_top = 10
	fps_label.set_anchored(true)
	fps_label.modulate = Color(1, 1, 1)
func _process(delta: float) -> void:
	# Update the FPS counter every frame
	if fps_label:
		fps_label.text = "FPS: " + str(Engine.get_frames_per_second())
