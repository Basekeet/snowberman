extends Node2D

# NOT USED

var time = 5.0
var current_time = 0
var enemy : CharacterBody2D
var player : CharacterBody2D
var LIMIT = 0.2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var min_radius = max(get_viewport().size[0], get_viewport().size[1]) * 0.005
	var max_radius = max(get_viewport().size[0], get_viewport().size[1]) * 0.25
	

	var d = enemy.position.distance_to(player.position)
	if d <= max_radius:
		show()
	if d < min_radius or enemy.is_dead:
		get_parent().remove_child(self)
	$Sprite2D.global_scale = Vector2(d / max_radius, d / max_radius)
	current_time += delta
	
