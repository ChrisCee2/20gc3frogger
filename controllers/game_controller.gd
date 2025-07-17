class_name GameController extends Node

@export var play_area: Area2D
@export var start_position: Vector2 = Vector2.ZERO # Should get start position from play area
@export var player: Player
@export_range(1, 10) var lives: int = 3

func _ready() -> void:
	player.fail.connect(_on_player_fail)

func _on_player_fail() -> void:
	lives -= 1
	player.deactivate()
	# Should play fail animation and on signal of animation complete, force position
	player.teleport(start_position)
	player.activate()
