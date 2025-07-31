class_name EndFrame extends TextureRect

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var win_sprite_sheet: CompressedTexture2D = preload("res://sprites/sprite_sheets/win_frame.png")

func _ready() -> void:
	hide()

func show_win() -> void:
	texture.atlas = win_sprite_sheet
	show()
	animation_player.play("frame")
