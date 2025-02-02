extends AudioStreamPlayer2D


@export var bpm := 120
@export var measures := 4

@export var spawnBeforeBeatSeconds := 2
@export var TrekOffset := 1
var smallTimer = 0.000001

# Tracking the beat and song position
var song_position = 0.0
var song_position_in_beats = 1
var sec_per_beat = 60.0 / bpm
var last_reported_beat = 0
var beats_before_start = 0
var measure = 1

# Determining how close to the beat an event is
var closest = 0
var time_off_beat = 0.0

signal beat(position)
signal measure_beat(position)


func _ready():
	sec_per_beat = 60.0 / bpm


func _physics_process(_delta):
	if playing:
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
		song_position -= AudioServer.get_output_latency()
		song_position_in_beats = int(floor(song_position / sec_per_beat)) + beats_before_start
		_report_beat()
		

func get_beat_proxymity():
	var proxymity = song_position / sec_per_beat - floor(song_position / sec_per_beat)
	return min(proxymity, 1 - proxymity)


func _report_beat():
	if last_reported_beat < song_position_in_beats:
		if measure > measures:
			measure = 1
		emit_signal("beat", song_position_in_beats)
		emit_signal("measure_beat", measure)
		last_reported_beat = song_position_in_beats
		measure += 1


func play_with_beat_offset(num):
	beats_before_start = num
	if beats_before_start != 0:
		$Timer.wait_time = beats_before_start
	else:
		beats_before_start = smallTimer
		$Timer.wait_time = smallTimer
	$Timer.start()


func closest_beat(nth):
	closest = int(round((song_position / sec_per_beat) / nth) * nth) 
	time_off_beat = abs(closest * sec_per_beat - song_position)
	return Vector2(closest, time_off_beat)


func play_from_beat(beat, offset):
	play()
	seek(beat * sec_per_beat)
	beats_before_start = offset
	measure = beat % measures


func _on_timer_timeout() -> void:
	#song_position_in_beats += 1
	#if song_position_in_beats < beats_before_start - 1:
		#$Timer.start()
	#elif song_position_in_beats == beats_before_start - 1:
		#
		#$Timer.wait_time = $Timer.wait_time - (AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency())
		#$Timer.start()
	#else:
		#play()
		#$Timer.stop()
	#_report_beat()
	
	if $Timer.wait_time == beats_before_start:
		$Timer.wait_time = spawnBeforeBeatSeconds
		$Timer.start()
		var pos = (spawnBeforeBeatSeconds + 3) % 4 
		if pos == 0:
			pos = 4
		#emit_signal("measure_beat", pos)
	else:
		play()
		$Timer.stop()
		_report_beat()
