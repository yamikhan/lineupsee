extends CharacterBody3D

# Constants
const SPEED = 5.0
const ACCELERATION = 10.0
const DECELERATION = 8.0
const JUMP_VELOCITY = 4.5
const GRAVITY = Vector3(0, -9.8, 0)
const MOUSE_SENSITIVITY = 0.006  # Adjust mouse sensitivity as needed

# Camera node reference
@export var camera: NodePath

# Vertical rotation tracking
var pitch_angle = 0.0  # Camera pitch angle in radians

func _ready() -> void:
	# Hide the mouse cursor and capture it
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# Ensure the camera node is assigned
	if not has_node(camera):
		print("Camera node not set or missing!")
	else:
		$camera.rotation_degrees.x = 0  # Reset pitch

func _input(event: InputEvent) -> void:
	# Handle mouse motion for rotation
	if event is InputEventMouseMotion:
		# Rotate the character horizontally (yaw)
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)

		# Adjust vertical camera rotation (pitch)
		pitch_angle -= event.relative.y * MOUSE_SENSITIVITY
		pitch_angle = clamp(pitch_angle, deg_to_rad(-89), deg_to_rad(89))  # Clamp pitch between -89° and 89°

		# Apply pitch to the camera
		if has_node(camera):
			$camera.rotation.x = pitch_angle

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	handle_movement(delta)
	handle_jump()

func apply_gravity(delta: float) -> void:
	# Apply gravity if not on the floor
	if not is_on_floor():
		velocity.y += GRAVITY.y * delta

func handle_movement(delta: float) -> void:
	# Get input direction
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction != Vector3.ZERO:
		# Accelerate toward the input direction
		var target_velocity = direction * SPEED
		velocity.x = lerp(velocity.x, target_velocity.x, ACCELERATION * delta)
		velocity.z = lerp(velocity.z, target_velocity.z, ACCELERATION * delta)
	else:
		# Decelerate smoothly when no input is given
		velocity.x = lerp(velocity.x, 0.0, DECELERATION * delta)
		velocity.z = lerp(velocity.z, 0.0, DECELERATION * delta)

	# Move the character while detecting collisions
	move_and_slide()

func handle_jump() -> void:
	# Jump when the jump action is pressed and the character is on the floor
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
