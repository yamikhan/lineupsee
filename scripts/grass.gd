@tool
extends Node3D

func _ready():
	var arrmesh = ArrayMesh.new()
	var surf_tool = SurfaceTool.new()
	surf_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	# Cube faces with vertices
	var faces = [
		# Bottom Face
		["bottom", [Vector3(0, 0, 0), Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(1, 0, 1)]],
		# Top Face
		["top", [Vector3(0, 1, 0), Vector3(1, 1, 0), Vector3(0, 1, 1), Vector3(1, 1, 1)]],
		# Front Face
		["front", [Vector3(0, 0, 1), Vector3(1, 0, 1), Vector3(0, 1, 1), Vector3(1, 1, 1)]],
		# Back Face
		["back", [Vector3(0, 0, 0), Vector3(0, 1, 0), Vector3(1, 0, 0), Vector3(1, 1, 0)]],
		# Left Face
		["left", [Vector3(0, 0, 0), Vector3(0, 0, 1), Vector3(0, 1, 0), Vector3(0, 1, 1)]],
		# Right Face
		["right", [Vector3(1, 0, 0), Vector3(1, 1, 0), Vector3(1, 0, 1), Vector3(1, 1, 1)]]
	]
	
	var uvs = [
		Vector2(0, 1), Vector2(1, 1), Vector2(0, 0), Vector2(1, 0)
	]

	# Check if a face should be rendered
	for face in faces:
		var face_name = face[0]
		var face_vertices = face[1]

		if should_render_face(face_name):
			surf_tool.set_uv(uvs[0])
			surf_tool.add_vertex(face_vertices[0])
			surf_tool.set_uv(uvs[1])
			surf_tool.add_vertex(face_vertices[1])
			surf_tool.set_uv(uvs[2])
			surf_tool.add_vertex(face_vertices[2])
			
			surf_tool.set_uv(uvs[1])
			surf_tool.add_vertex(face_vertices[1])
			surf_tool.set_uv(uvs[3])
			surf_tool.add_vertex(face_vertices[3])
			surf_tool.set_uv(uvs[2])
			surf_tool.add_vertex(face_vertices[2])

	surf_tool.generate_normals()
	surf_tool.commit(arrmesh)
	
	# Create the StaticBody3D
	var static_body = StaticBody3D.new()
	
	# Create the MeshInstance3D for the mesh
	var sq = MeshInstance3D.new()
	sq.mesh = arrmesh
	
	# Load the texture and create the material
	var img = preload("res://asset/img/grass.jpg")
	var material = StandardMaterial3D.new()
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	material.albedo_texture = img
	sq.material_override = material
	
	# Add the MeshInstance3D to the StaticBody3D
	static_body.add_child(sq)

	# Create a CollisionShape3D for the mesh
	var collision_shape = CollisionShape3D.new()
	var box_shape = BoxShape3D.new()
	box_shape.size = Vector3(1, 1, 1)
	collision_shape.shape = box_shape
	
	static_body.add_child(collision_shape)
	add_child(static_body)

# Check if a face should be rendered
func should_render_face(face_name: String) -> bool:
	# Implement logic to check if adjacent cube blocks this face
	# For simplicity, assume all faces should render for now
	return true
