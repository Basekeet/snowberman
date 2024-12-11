extends Node2D

@onready var pauseMenu = $Pausemenu
@onready var player = $Player
@onready var progress = $ProgressBar
var directions = ["left", "up", "right", "down"]
var count = 0
var paused = false
var time = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	paused = false
	count = 0
	Engine.time_scale = 1
	pauseMenu.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	if Input.is_action_just_pressed("menu"):
		pause()
	if not paused:
		progress.value = 100 * (time / 60.0)
		if player.health <= 0:
			get_tree().change_scene_to_file("res://scenes/lose_menu.tscn")
		if time > 60:
			get_tree().change_scene_to_file("res://scenes/winmenu.tscn")
		
		if randi() % 10000 < 100:
			var q = load("res://scenes/Enemy.tscn")
			var cir = load("res://scenes/circle.tscn")
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
			
			var c = cir.instantiate()
			c.time = randi() % 5 + 1
			c.player = player
			c.enemy = e
			$Player.add_child(c)

func pause():
	if paused:
		pauseMenu.hide()
		Engine.time_scale = 1
	else:
		pauseMenu.show()
		Engine.time_scale = 0
	paused = !paused
