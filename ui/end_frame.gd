class_name EndFrame extends TextureRect

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var win_sprite_sheet: CompressedTexture2D = preload("res://sprites/sprite_sheets/win_frame.png")
var lose_dog_sprite_sheet: CompressedTexture2D = preload("res://sprites/sprite_sheets/lose_dog_frame.png")
var lose_oob_sprite_sheet: CompressedTexture2D = preload("res://sprites/sprite_sheets/lose_oob_frame.png")
var lose_water_sprite_sheet: CompressedTexture2D = preload("res://sprites/sprite_sheets/lose_water_frame.png")

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

func show_lose_oob() -> void:
	texture.atlas = lose_oob_sprite_sheet
	visible = true
	animation_player.play("frame")

func show_lose_water() -> void:
	texture.atlas = lose_water_sprite_sheet
	visible = true
	animation_player.play("frame")
