extends TextureRect
# all the little pictures in the photo album ui

var viewing_pic: TextureRect
var selected = false

var viewing_selected = false

func _ready() -> void:
	viewing_pic = get_tree().root.get_node("Root/UI/PhotoAlbum/ViewingPic")
	viewing_pic.set_visible(false)
	viewing_pic.mouse_entered.connect(viewing_pic_moused)
	viewing_pic.mouse_exited.connect(viewing_pic_unmoused)

func _process(_delta: float) -> void:
	if not viewing_selected and selected and Input.is_action_just_pressed("Click"):
		viewing_pic.set_visible(true)
		viewing_pic.texture = texture
		
	elif viewing_selected and Input.is_action_just_pressed("Click"):
		viewing_pic.set_visible(false)
		viewing_selected = false


func _on_mouse_entered() -> void:
	if not viewing_selected:
		set_modulate(Color(1, 1, 1, 0.5))
	selected = true


func _on_mouse_exited() -> void:
	set_modulate(Color(1, 1, 1, 1))
	selected = false


func viewing_pic_moused():
	viewing_selected = true

func viewing_pic_unmoused():
	viewing_selected = false
	
