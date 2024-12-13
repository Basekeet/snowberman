extends Node2D

@onready var pauseMenu = $UI/Pausemenu
@onready var player = $Player
@onready var progress = $UI/ProgressBar

var directions = ["left", "up", "right", "down"]
var enemy_count = 0
var elapsed_time = 0.0

var game_paused = false

var spawnBeforeBeatSeconds = 3
var TrekOffset = 0

var bpm = 115
var spawn_1_beat = 0
var spawn_2_beat = 0
var spawn_3_beat = 1
var spawn_4_beat = 0

var song_position = 0.0
var song_position_in_beats = 0
var last_spawned_beat = 0
var sec_per_beat = 60.0 / bpm
var rand = 0

func set_default():
	game_paused = false
	enemy_count = 0
	Engine.time_scale = 1
	pauseMenu.hide()

func _ready() -> void:
	set_default()
	$AudioStreamPlayer.play_with_beat_offset(TrekOffset)

func _process(delta: float) -> void:
	elapsed_time += delta
	if Input.is_action_just_pressed("menu"):
		pause()
	if not game_paused:
		handle_progress()
		handle_game_finish()
		
		#if randi() % 10000 < 100:
			#var dir = randi() % 4
			#spawn_enemy(dir)

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
	
	var distToSpawn = abs(spawns[direction][0] + spawns[direction][1])
	var distToCollider = 0
	if direction == 0:
		distToCollider = abs(get_node("Player/AttackAreaRight/CollisionShape2D").position.x)
	elif direction == 1:
		distToCollider = abs(get_node("Player/AttackAreaDown/CollisionShape2D").position.y)
	elif direction == 2:
		distToCollider = abs(get_node("Player/AttackAreaLeft/CollisionShape2D").position.x)
	else:
		distToCollider = abs(get_node("Player/AttackAreaUp/CollisionShape2D").position.y)
	print(distToCollider, " ", distToSpawn, " ", direction)
	var totalDist = distToSpawn - distToCollider
	
	enemyInst.speed = totalDist / (spawnBeforeBeatSeconds * sec_per_beat)
	
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


func _on_audio_stream_player_measure_beat(position: Variant) -> void:
	position = (position + 4 - spawnBeforeBeatSeconds) % 4
	if position == 0:
		position = 4
	if position == 1:
		_spawn_notes(spawn_1_beat)
	elif position == 2:
		_spawn_notes(spawn_2_beat)
	elif position == 3:
		_spawn_notes(spawn_3_beat)
	elif position == 4:
		_spawn_notes(spawn_4_beat)

func _spawn_notes(to_spawn):
	if to_spawn > 0:
		var direction = randi() % 4
		spawn_enemy(direction)
	#if to_spawn > 1:
		#while rand == r:
			#rand = randi() % 3
		#r = rand
		#spawn_enemy(r)

func _on_audio_stream_player_beat(position: Variant) -> void:
	print("position ", position)
	song_position_in_beats = position + spawnBeforeBeatSeconds
	print("new position ", song_position_in_beats)
	if song_position_in_beats > 27:
		spawn_1_beat = 1
		spawn_2_beat = 1
		spawn_3_beat = 1
		spawn_4_beat = 1
	if song_position_in_beats > 89:
		spawn_1_beat = 1
		spawn_2_beat = 0
		spawn_3_beat = 1
		spawn_4_beat = 0
	if song_position_in_beats > 123:
		spawn_1_beat = 0
		spawn_2_beat = 1
		spawn_3_beat = 0
		spawn_4_beat = 1
	if song_position_in_beats > 153:
		spawn_1_beat = 1
		spawn_2_beat = 1
		spawn_3_beat = 1
		spawn_4_beat = 1
	if song_position_in_beats > 185:
		spawn_1_beat = 1
		spawn_2_beat = 1
		spawn_3_beat = 1
		spawn_4_beat = 1
	if song_position_in_beats > 219:
		spawn_1_beat = 0
		spawn_2_beat = 1
		spawn_3_beat = 1
		spawn_4_beat = 1
	if song_position_in_beats > 249:
		spawn_1_beat = 1
		spawn_2_beat = 1
		spawn_3_beat = 1
		spawn_4_beat = 1
	if song_position_in_beats > 279:
		spawn_1_beat = 0
		spawn_2_beat = 2
		spawn_3_beat = 0
		spawn_4_beat = 2
	if song_position_in_beats > 313:
		spawn_1_beat = 3
		spawn_2_beat = 2
		spawn_3_beat = 2
		spawn_4_beat = 1
	if song_position_in_beats > 369:
		spawn_1_beat = 1
		spawn_2_beat = 0
		spawn_3_beat = 0
		spawn_4_beat = 0
	if song_position_in_beats > 387:
		spawn_1_beat = 0
		spawn_2_beat = 0
		spawn_3_beat = 0
		spawn_4_beat = 0
