extends Control

@export var content: RichTextLabel
@export var pause_timer: Timer

@export var dialogue_file: JSON
@export var dialogue_manager: Control

var all_text = {}
var selected_text = []
var current_speaker
var line_num

var talk_timer: int
var talk_timer_max: int
var talk_timer_active: bool
var showing_dialogue: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# prepare text displayer
	content.set_use_bbcode(true)
	talk_timer = 0
	talk_timer_max = 2
	talk_timer_active = false
	showing_dialogue = false
	
	load_text_file()
	dialogue_manager.npc_talking.connect(set_speaker)
	set_visible(false)

func load_text_file():
	var file = FileAccess.open(dialogue_file.resource_path, FileAccess.READ)
	if file:
		all_text = JSON.parse_string(file.get_as_text())
	else:
		print("Error: couldn't load dialogue text file")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if talk_timer_active:
		talk_timer += 1
		if talk_timer >= talk_timer_max:
			talk_timer = 0
			_on_type_timer_timeout()

# this gets called every time player interacts with npc
func set_speaker(speaker, line):
	current_speaker = speaker
	# display next line for this speaker
	if line >= len(all_text[speaker]):
		# character done speaking
		finish_dialogue()
	else:
		update_text(all_text[speaker][line])



# loads and prepares the next line
func update_text(text: String):
	content.text = text
	content.visible_characters = 0
	talk_timer_active = true

func start_dialogue():
	set_visible(true)
	
func finish_dialogue():
	set_visible(false)
	


# displays the currently selected text (words inside content.text rn)
func _on_type_timer_timeout() -> void:
	if content.visible_characters < content.text.length():
		content.visible_characters += 1
	else:
		talk_timer_active = false

func get_num_of_lines(character_name):
	var all_lines = all_text[character_name]
	return len(all_lines)
