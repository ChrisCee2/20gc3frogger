class_name Expirable extends Node

@export var area: Area2D
@export var area_to_expire: Area2D

var should_expire: bool = false

func _ready() -> void:
	if area:
		_initialize_area()
	if area_to_expire == null:
		area_to_expire = area

func set_area(new_area: Area2D) -> void:
	if area:
		area.area_entered.disconnect(_on_enter)
		area.area_exited.disconnect(_on_exit)
	area = new_area
	_initialize_area()

func _initialize_area() -> void:
	area.area_entered.connect(_on_enter)
	area.area_exited.connect(_on_exit)

func _on_enter(entered_area: Area2D) -> void:
	if entered_area is PlayArea:
		should_expire = true

func _on_exit(exited_area: Area2D) -> void:
	if exited_area is PlayArea and should_expire:
		area_to_expire.queue_free()
