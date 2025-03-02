extends Control

@export var player: CharacterBody3D
@export var ui: Control # for hiding UI during picture taking
@export var flash: AnimationPlayer
@export var gallery_pic_scene: PackedScene
@export var sound: AudioStreamPlayer

var grid

var photos_taken = 0
var fileName = "player_photo"

signal has_photo_taken(character)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.snap.connect(on_snap)
	
	var dir
	if not FileAccess.file_exists("user://photos/"):
		var try = DirAccess.make_dir_recursive_absolute("user://photos/")
		if try != OK:
			print("Error: couldn't create photos directory, code ", try)

	dir = DirAccess.open("user://photos/")

	# clear photo folder
	#for file in DirAccess.get_files_at("user://photos/"): # hopefully this only happens when the game opens
		#dir.remove(file)
	
	grid = get_node("ScrollContainer/MarginContainer/GridContainer")


func on_snap():
	player.camera_overlay.set_visible(false)
	ui.set_visible(false)
	flash.play("flash") # because of timing this basically plays after the photo is taken/ui hides
	sound.play()
	await RenderingServer.frame_post_draw # wait for everything to catch up
	
	var image = get_viewport().get_texture().get_image()
	var save_path = "user://photos/"+fileName+str(photos_taken)+".png"
	image.save_png(save_path)
	photos_taken += 1
	
	add_to_gallery(save_path) # add to the in-game gallery ui element
	
	player.camera_overlay.set_visible(true) # put them back
	ui.set_visible(true)
	
	# if there's a character in range, record that in the quests
	if player.selected_thing:
		if player.selected_thing.is_in_group("NPC"):
			has_photo_taken.emit(player.selected_thing.character_name)

func add_to_gallery(imagePath):
	var image = Image.new()
	image.load(imagePath)
	var texture = ImageTexture.create_from_image(image)
	var new_pic = gallery_pic_scene.instantiate()
	#print("Path: ", imagePath, " Image found: ", image)
	#new_pic.texture = load(imagePath)
	new_pic.texture = texture
	#new_pic.size
	grid.add_child(new_pic)
