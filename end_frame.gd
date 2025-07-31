class_name EndFrame extends PanelContainer

@onready var win_sprite: Sprite2D = $WinSprite

func _ready() -> void:
	win_sprite.hide()

func show_win() -> void:
	win_sprite.show()
	_play_animation(win_sprite)

func _play_animation(sprite: Sprite2D) -> void:
	if sprite.has_node("AnimationPlayer"):
		sprite.get_node("AnimationPlayer").play("frame")
