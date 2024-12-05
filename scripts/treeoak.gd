@tool
extends Node3D

func _ready():
	var arrmesh = ArrayMesh.new()
	var surf_tool = SurfaceTool.new()
	surf_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var faces = [
		# Bottom Face
		[Vector3(0, 0, 0), Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(1, 0, 1)],
		# Top Face
		[Vector3(0, 1, 0), Vector3(1, 1, 0), Vector3(0, 1, 1), Vector3(1, 1, 1)],
		# Front Face
		[Vector3(0, 0, 1), Vector3(1, 0, 1), Vector3(0, 1, 1), Vector3(1, 1, 1)],
		# Back Face
		[Vector3(0, 0, 0), Vector3(0, 1, 0), Vector3(1, 0, 0), Vector3(1, 1, 0)],
		# Left Face
		[Vector3(0, 0, 0), Vector3(0, 0, 1), Vector3(0, 1, 0), Vector3(0, 1, 1)],
		# Right Face
		[Vector3(1, 0, 0), Vector3(1, 1, 0), Vector3(1, 0, 1), Vector3(1, 1, 1)]
	]
	
	var uvs = [
		Vector2(0, 1), Vector2(1, 1), Vector2(0, 0), Vector2(1, 0)
	]

	for face in faces:
		surf_tool.set_uv(uvs[0])
		surf_tool.add_vertex(face[0])
		surf_tool.set_uv(uvs[1])
		surf_tool.add_vertex(face[1])
		surf_tool.set_uv(uvs[2])
		surf_tool.add_vertex(face[2])
		
		surf_tool.set_uv(uvs[1])
		surf_tool.add_vertex(face[1])
		surf_tool.set_uv(uvs[3])
		surf_tool.add_vertex(face[3])
		surf_tool.set_uv(uvs[2])
		surf_tool.add_vertex(face[2])

	surf_tool.generate_normals()  # Automatically calculates normals
	surf_tool.commit(arrmesh)
	
	# Create the StaticBody3D
	var static_body = StaticBody3D.new()
	
	# Create the MeshInstance3D for the mesh
	var sq = MeshInstance3D.new()
	sq.mesh = arrmesh
	
	# Load the texture and create the material
	var img = preload("res://asset/img/tree.jpg")
	var material = StandardMaterial3D.new()
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	material.albedo_texture = img
	sq.material_override = material
	
	# Add the MeshInstance3D to the StaticBody3D
	static_body.add_child(sq)

	# Create a CollisionShape3D for the mesh
	var collision_shape = CollisionShape3D.new()
	var box_shape = BoxShape3D.new()
	
	# Set the size of the BoxShape to match the mesh
	box_shape.size = Vector3(1, 1, 1)  # Adjust this to match your mesh size
	collision_shape.shape = box_shape
	
	# Add the CollisionShape3D to the StaticBody3D
	static_body.add_child(collision_shape)
	
	# Add the StaticBody3D to the scene
	add_child(static_body)
