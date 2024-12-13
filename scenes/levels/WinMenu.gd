extends Control

func _ready() -> void:
	$VBoxContainer/Label2.text = "Excellent: " + str(Variables.excellentScore)
	$VBoxContainer/Label3.text = "Good: " + str(Variables.goodScore)
	$VBoxContainer/Label4.text = "Miss: " + str(Variables.missScore)
	
	
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/MainMenu.tscn")
