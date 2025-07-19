class_name AnimatedButton extends TextureButton

@export var animation_player: AnimationPlayer

func _ready() -> void:
	play_animation("normal")

func play_animation(animation_name: String):
	if animation_player.has_animation(animation_name) and \
	animation_player.current_animation != animation_name:
		animation_player.play(animation_name)
