class_name Lives extends HBoxContainer

@export var life_sprite: Sprite2D

func remove_life() -> void:
	var life = get_child(0)
	if life:
		life.queue_free()

func add_life() -> void:
	var panel: Panel = Panel.new()
	var sprite: Sprite2D = life_sprite.duplicate()
	sprite.show()
	panel.add_child(sprite)
	panel.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(panel)

func set_lives(lives: int) -> void:
	for life in get_children():
		life.queue_free()
	for i in range(lives):
		add_life()
