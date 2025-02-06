extends CharacterBody3D


const SPEED = 10.0
const mouse_sens = .002
const raycast_length = 1000
#const JUMP_VELOCITY = 4.5

@export var cam_arm: Node3D
@export var player_view: Camera3D
@export var interact_range: Area3D
@export var interact_ray: RayCast3D

var things_in_range = [] # this is updated whenever things enter InteractRange using signals
var selected_thing


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
	
	
	# what is player looking at?
	# do raycast
	#if interact_ray.is_colliding():
	var target = interact_ray.get_collider()
	
	if target != selected_thing:
		if target:
			if target.is_in_group("Interactable"):
				target.highlight()
		if selected_thing:
			if selected_thing.is_in_group("Interactable"):
				selected_thing.unhighlight()
	selected_thing = target
	
	
	
	# Handle interaction button
	if Input.is_action_just_pressed("Interact"):
		# raycast
		if selected_thing:
			if selected_thing.is_in_group("Door"):
				# send signal opening_door(thing)
				var destination = selected_thing.on_interact()
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


# used for moving the player between doors
func teleport(destination: Vector3):
	# disable camera or fade to black
	reset_physics_interpolation()
	set_position(destination)
