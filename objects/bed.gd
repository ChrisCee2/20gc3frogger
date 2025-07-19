class_name Bed extends Area2D

func deactivate() -> void:
	monitoring = false
	set_deferred("monitorable", false)
	hide()
