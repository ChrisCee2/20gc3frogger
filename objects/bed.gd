class_name Bed extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("idle")

func deactivate() -> void:
	monitoring = false
	set_deferred("monitorable", false)
	hide()
