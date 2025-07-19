class_name AnimatedButton extends Button

@export var sprite: Sprite2D
@export var animation_player: AnimationPlayer

var original_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	play_animation("normal")
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)
	original_position = sprite.global_position

func _process(delta: float) -> void:
	sprite.global_position = global_position
	size = sprite.get_rect().size
	global_position = original_position

func _on_focus_entered() -> void:
	play_animation("focus")

func _on_focus_exited() -> void:
	play_animation("normal")

func play_animation(animation_name: String):
	if animation_player.has_animation(animation_name) and \
	animation_player.current_animation != animation_name:
		animation_player.play(animation_name)
