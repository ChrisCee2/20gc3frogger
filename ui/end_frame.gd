class_name EndFrame extends TextureRect

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var win_sprite_sheet: CompressedTexture2D = preload("res://sprites/sprite_sheets/win_frame.png")
var lose_dog_sprite_sheet: CompressedTexture2D = preload("res://sprites/sprite_sheets/lose_dog_frame.png")

func _ready() -> void:
	visible = false

func show_win() -> void:
	texture.atlas = win_sprite_sheet
	visible = true
	animation_player.play("frame")

func show_lose_dog() -> void:
	texture.atlas = lose_dog_sprite_sheet
	visible = true
	animation_player.play("frame")
