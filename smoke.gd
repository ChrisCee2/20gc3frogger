class_name Smoke extends CPUParticles2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	finished.connect(_on_finished)

func play() -> void:
	animation_player.play("smoke")
	emitting = true

func _on_finished() -> void:
	animation_player.stop()
	queue_free()
