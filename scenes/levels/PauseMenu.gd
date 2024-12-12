extends Control

@onready var main = $"../"

func _on_resume_pressed() -> void:
	main.pause()

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/MainMenu.tscn")
	
