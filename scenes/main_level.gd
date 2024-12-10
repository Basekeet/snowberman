extends Node2D

var directions = ["left", "up", "right", "down"]
var count = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if randi() % 10000 < 100:
		var q = load("res://scenes/Enemy.tscn")
		
		var e = q.instantiate()
		var r = randi() % 4
		e.direction = directions[r]
		var size_x = get_viewport().size[0]
		var size_y = get_viewport().size[1]
		var spawns = [Vector2(size_x / 2, 0), Vector2(0, size_y / 2), Vector2(-size_x / 2, 0), Vector2(0, - size_y / 2)]
		e.position = spawns[r]
		e.name = "Enemy" + str(count)
		count += 1
		print(e.direction)
		if e.direction == "up":
			e.z_index = count
		if e.direction == "down":
			e.z_index = -count
		add_child(e)
