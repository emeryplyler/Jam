extends CharacterBody3D

@export var character_name: String
#const deathsprite = preload("res://npcs/npc/skull.png")
@export var neutral_sprite: Texture
@export var talking_sprite: Texture
@export var current_sprite: int : set = set_current_sprite # variable for animator to use
var animator: AnimationPlayer
var sprite_3d: Sprite3D
var deathsprite

var ui: Control # interaction icon
var dialogue_manager: Control # this is for sending signals to the dialogue script
var dialogue_script: Control # this is for getting the number of lines
var photo_cam: Control # for hiding after picture taken
var visibility_notifier: VisibleOnScreenNotifier3D
var block_number: int
var line_number: int # index of line that the character has just said
var num_of_lines: int
var usingRandomBlock = false
var midGame = false
var vanish = false
var gone = false

#var talking = false
#var talk_anim_timer = 0
#var talk_anim_max = 50 # talk animation speed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui = get_tree().root.get_node("Root/UI/E")
	dialogue_manager = get_tree().root.get_node("Root/UI/DialogueManager")
	dialogue_script = get_tree().root.get_node("Root/UI/Dialogue")
	photo_cam = get_tree().root.get_node("Root/UI/PhotoAlbum")
	visibility_notifier = get_node("VisibilityNotifier")
	get_tree().root.get_node("Root/UI/Quests/Quest2").dark_picture_quest_begin.connect(reveal_death)

	block_number = 0
	line_number = -1
	num_of_lines = dialogue_script.get_num_of_lines(character_name, block_number)
	photo_cam.has_photo_taken.connect(have_photo_taken)
	
	# prepare talk animation
	animator = get_node("AnimationPlayer")
	sprite_3d = get_node("Sprite3D")
	
	# prepare deathsprite
	if character_name != "Howl" and character_name != "Howl ":
		deathsprite = load("res://npcs/npc/" + character_name.to_lower() + "_death.png")


func _physics_process(delta: float) -> void:
	#if not is_on_floor():
		#velocity += get_gravity() * delta
	#
	#move_and_slide()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if vanish and not gone and not visibility_notifier.is_on_screen():
		set_visible(false)
		gone = true
	#if talking:
		#animator.play("talk")
	#else:
		#animator.stop()


func highlight():
	if not gone:
		ui.set_visible(true)
		ui.get_node("Chat").set_visible(true)
	

func unhighlight():
	ui.set_visible(false)
	ui.get_node("Chat").set_visible(false)

# is called whenever the player interacts with npc
# returns whether npc is still talking for the player script
func on_interact():
	if usingRandomBlock and line_number == -1:
		if not midGame:
			random_block(2, 4)
	if block_number >= 6 and block_number <= 8 and line_number == -1:
		random_block(6, 8)
	
	if line_number < num_of_lines - 1:
		line_number += 1
		dialogue_manager.npc_talking.emit(character_name, block_number, line_number)
		return true
	else:
		if block_number == 1 and line_number == 3: # ok not proud of this ngl
			set_block(4)
			stop_talking()
			line_number += 1
			return false
		if block_number == 5 and line_number == 7:
			set_block(8) # start repeating these lines
			stop_talking()
			line_number += 1
			return false
		if character_name == "Howl ":
			stop_talking()
			gone = true
			return false
		else:
			stop_talking()
			return false

# called by player when the npc first starts talking
func start_talking():
	dialogue_script.start_dialogue()
	on_interact()
	animator.play("talk")


func stop_talking():
	dialogue_script.finish_dialogue()
	line_number -= 1 # reset line number to the last line character said
	animator.stop()

# is called when signal emitted allowing continue
# for howl this is connected to quest system
func next_block():
	block_number += 1 # finished this current block, go to next one
	num_of_lines = dialogue_script.get_num_of_lines(character_name, block_number)
	line_number = -1 # reset line num

func set_block(block_index):
	block_number = block_index
	num_of_lines = dialogue_script.get_num_of_lines(character_name, block_number)
	line_number = -1

func random_block(rangeMin, rangeMax):
	#block_number = randi_range(rangeMin, rangeMax)
	block_number += 1
	if block_number > rangeMax:
		block_number = rangeMin
	line_number = -1
	num_of_lines = dialogue_script.get_num_of_lines(character_name, block_number)

# used by animator
func set_current_sprite(frame: int):
	if frame == 0:
		sprite_3d.texture = neutral_sprite
	else:
		sprite_3d.texture = talking_sprite


func have_photo_taken(chara):
	if chara != "Howl" and chara != "Howl ":
		if chara == character_name:
			vanish = true

func reveal_death():
	if character_name != "Howl" and character_name != "Howl ":
		get_node("Sprite3D").texture = deathsprite
		set_visible(true)
