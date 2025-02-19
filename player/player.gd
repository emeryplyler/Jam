extends CharacterBody3D


const SPEED = 100.0
const mouse_sens = .002
const raycast_length = 1000
#const JUMP_VELOCITY = 4.5

@export var cam_arm: Node3D
@export var player_view: Camera3D
@export var interact_ray: RayCast3D
@export var photo_album: Control
@export var camera_overlay: Control

var talking: bool = false
var talking_to
var taking_photo: bool = false

var things_in_range = [] # this is updated whenever things enter InteractRange using signals
var selected_thing

signal snap

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	photo_album.set_visible(false)
	camera_overlay.set_visible(false)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration
	# can't move if talking maybe
	# TODO: change later?
	if not talking_to:
		var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	
	
	# what is player looking at?
	raycasting()
	
	# Handle interaction button
	if Input.is_action_just_pressed("Interact"):
		if talking:
			# player is talking to npc, continue dialogue
			if not talking_to.on_interact():
				talking = false
				talking_to = null
		else:
			# selected thing comes from the raycast function
			if selected_thing:
				if selected_thing.is_in_group("Door"):
					# send signal opening_door(thing)
					var destination = selected_thing.on_interact()
					teleport(destination)
				elif selected_thing.is_in_group("NPC"):
					selected_thing.start_talking()
					talking_to = selected_thing
					talking = true # enter talking state
	
	if Input.is_action_just_pressed("Open Photos"):
		photo_album.set_visible(not photo_album.is_visible())
		# toggle cursor
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if Input.is_action_just_pressed("Toggle Camera"):
		var camera_on = camera_overlay.is_visible() # not camera_on is the new value after pressing the button
		camera_overlay.set_visible(not camera_on)
		taking_photo = not camera_on
	
	if Input.is_action_just_pressed("Click"):
		if taking_photo:
			snap.emit()
	
	# TODO: show cursor button is only for debug
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

func raycasting():
	var target = interact_ray.get_collider()
	
	if target != selected_thing:
		if target:
			if target.is_in_group("Interactable"):
				target.highlight()
		if selected_thing:
			if selected_thing.is_in_group("Interactable"):
				selected_thing.unhighlight()
	selected_thing = target


# used for moving the player between doors
func teleport(destination: Vector3):
	# disable camera or fade to black
	reset_physics_interpolation()
	set_position(destination)
