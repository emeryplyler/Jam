extends Control

@export var player: CharacterBody3D
@export var ui: Control # for hiding UI during picture taking
@export var flash: AnimationPlayer
@export var gallery_pic_scene: PackedScene

var grid

var photos_taken = 0
var fileName = "player_photo"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.snap.connect(on_snap)

	var dir = DirAccess.open("res://player/photos/")

	# clear photo folder
	for file in DirAccess.get_files_at("res://player/photos/"): # hopefully this only happens when the game opens
		dir.remove(file)
	
	grid = get_node("ScrollContainer/MarginContainer/GridContainer")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_snap():
	player.camera_overlay.set_visible(false)
	ui.set_visible(false)
	flash.play("flash") # because of timing this basically plays after the photo is taken/ui hides
	await RenderingServer.frame_post_draw # wait for everything to catch up
	
	var image = get_viewport().get_texture().get_image()
	var save_path = "res://player/photos/"+fileName+str(photos_taken)+".png"
	image.save_png(save_path)
	photos_taken += 1
	
	add_to_gallery(save_path) # add to the in-game gallery ui element
	
	player.camera_overlay.set_visible(true) # put them back
	ui.set_visible(true)

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
