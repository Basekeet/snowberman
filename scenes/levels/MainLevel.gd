extends Node2D

@onready var pauseMenu = $UI/Pausemenu
@onready var player = $Player
@onready var progress = $UI/ProgressBar

var directions = ["left", "up", "right", "down"]
var enemy_count = 0
var elapsed_time = 0.0

var game_paused = false

func set_default():
	game_paused = false
	enemy_count = 0
	Engine.time_scale = 1
	pauseMenu.hide()

func _ready() -> void:
	set_default()

func _process(delta: float) -> void:
	elapsed_time += delta
	if Input.is_action_just_pressed("menu"):
		pause()
	if not game_paused:
		handle_progress()
		handle_game_finish()
		
		if randi() % 10000 < 100:
			var dir = randi() % 4
			spawn_enemy(dir)

func handle_progress():
	progress.value = 100 * (elapsed_time / 60.0)

func handle_game_finish():
	if player.health <= 0:
		get_tree().change_scene_to_file("res://scenes/levels/LoseMenu.tscn")
	if elapsed_time > 60:
		get_tree().change_scene_to_file("res://scenes/levels/WinMenu.tscn")

var EnemyPreload = load("res://scenes/characters/Enemy.tscn")
var CirclePreload = load("res://scenes/misc/circle.tscn")

func spawn_enemy(direction):
	var enemyInst = EnemyPreload.instantiate()
	enemyInst.direction = directions[direction]
	var s = $TileMap.get_used_rect().size
	var size_x = s[0] * 16
	var size_y = s[1] * 16
	var spawns = [Vector2(size_x / 2, 0), Vector2(0, size_y / 2), Vector2(-size_x / 2, 0), Vector2(0, - size_y / 2)]
	enemyInst.position = spawns[direction]
	enemyInst.name = "Enemy" + str(enemy_count)
	enemy_count += 1
	if enemyInst.direction == "up":
		enemyInst.z_index = enemy_count
	if enemyInst.direction == "down":
		enemyInst.z_index = -enemy_count
	add_child(enemyInst)
	
	#var c = cir.instantiate()
	#c.time = randi() % 5 + 1
	#c.player = player
	#c.enemy = e
	#$Player.add_child(c)
			
func pause():
	if game_paused:
		pauseMenu.hide()
		Engine.time_scale = 1
	else:
		pauseMenu.show()
		Engine.time_scale = 0
	game_paused = !game_paused
