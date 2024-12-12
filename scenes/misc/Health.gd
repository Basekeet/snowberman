extends Control

@export var player : CharacterBody2D

func _process(delta: float) -> void:
	$HealthText.text = str(player.health)
