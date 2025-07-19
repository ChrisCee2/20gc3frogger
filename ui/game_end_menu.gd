class_name GameEndMenu extends Control

@onready var menu_button: BaseButton = $GridContainer/MenuButton
@export var enabled: bool = false

func _ready() -> void:
	if enabled:
		enable()
	else:
		disable()
	menu_button.pressed.connect(go_to_main_menu)
	menu_button.mouse_entered.connect(_on_enter)

func disable() -> void:
	hide()
	menu_button.disabled = true

func enable() -> void:
	show()
	menu_button.disabled = false

func go_to_main_menu() -> void:
	#AudioManager.play_audio(select_sfx)
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")

func _on_enter() -> void:
	return
	#AudioManager.play_audio(hover_sfx)
