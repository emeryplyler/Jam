extends CharacterBody3D


const SPEED = 10.0
const mouse_sens = .002
#const JUMP_VELOCITY = 4.5

@export var cam_arm: Node3D
@export var player_view: Camera3D
@export var interact_range: Area3D

var things_in_range = [] # this is updated whenever things enter InteractRange using signals

signal interact_door

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	
	# Handle interaction button
	if Input.is_action_just_pressed("Interact"):
		if things_in_range.size() > 0:
			for thing in things_in_range:
				if thing.is_in_group("Interactable"):
					if thing.is_in_group("Door"):
					# send signal opening_door(thing)
						emit_signal("interact_door", thing)
						var destination = thing.on_interact()
						teleport(destination)
						
	if Input.is_action_just_pressed("Show Cursor"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

	move_and_slide()

# Handle mouse input
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * mouse_sens
		
		cam_arm.rotation.x -= event.relative.y * mouse_sens
		cam_arm.rotation.x = clamp(cam_arm.rotation.x, deg_to_rad(-90), deg_to_rad(90))


func _on_interact_range_area_entered(area: Area3D) -> void:
	if area != interact_range:
		things_in_range.append(area)


func _on_interact_range_area_exited(area: Area3D) -> void:
	things_in_range.erase(area)


func teleport(destination: Vector3):
	# disable camera or fade to black
	reset_physics_interpolation()
	set_position(destination)
