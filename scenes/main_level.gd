extends Node2D

var directions = ["left", "up", "right", "down"]
var count = 0


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
var r = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer.play_with_beat_offset(8)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if randi() % 10000 < 100:
		#var r = randi() % 4
		#_spawn(r)
		
		
func _spawn(r : int) -> void:
	var q = load("res://scenes/Enemy.tscn")
	var e = q.instantiate()
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

func _on_AudioStreamPlayer_measure(position):
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
		var r = randi() % 4
		_spawn(r)
	if to_spawn > 1:
		while rand == r:
			rand = randi() % 3
		r = rand
		_spawn(r)


func _on_audio_stream_player_beat(position: Variant) -> void:
	print("beat")
	song_position_in_beats = position
	if song_position_in_beats > 36:
		spawn_1_beat = 1
		spawn_2_beat = 1
		spawn_3_beat = 1
		spawn_4_beat = 1
	if song_position_in_beats > 98:
		spawn_1_beat = 2
		spawn_2_beat = 0
		spawn_3_beat = 1
		spawn_4_beat = 0
	if song_position_in_beats > 132:
		spawn_1_beat = 0
		spawn_2_beat = 2
		spawn_3_beat = 0
		spawn_4_beat = 2
	if song_position_in_beats > 162:
		spawn_1_beat = 2
		spawn_2_beat = 2
		spawn_3_beat = 1
		spawn_4_beat = 1
	if song_position_in_beats > 194:
		spawn_1_beat = 2
		spawn_2_beat = 2
		spawn_3_beat = 1
		spawn_4_beat = 2
	if song_position_in_beats > 228:
		spawn_1_beat = 0
		spawn_2_beat = 2
		spawn_3_beat = 1
		spawn_4_beat = 2
	if song_position_in_beats > 258:
		spawn_1_beat = 1
		spawn_2_beat = 2
		spawn_3_beat = 1
		spawn_4_beat = 2
	if song_position_in_beats > 288:
		spawn_1_beat = 0
		spawn_2_beat = 2
		spawn_3_beat = 0
		spawn_4_beat = 2
	if song_position_in_beats > 322:
		spawn_1_beat = 3
		spawn_2_beat = 2
		spawn_3_beat = 2
		spawn_4_beat = 1
	if song_position_in_beats > 388:
		spawn_1_beat = 1
		spawn_2_beat = 0
		spawn_3_beat = 0
		spawn_4_beat = 0
	if song_position_in_beats > 396:
		spawn_1_beat = 0
		spawn_2_beat = 0
		spawn_3_beat = 0
		spawn_4_beat = 0
