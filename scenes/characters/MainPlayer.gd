extends CharacterBody2D

@export var tilemap : TileMap

var anim = "NONE"
var facing = "left"
var state = "idle"


var striked = false
var missed = false
var health = 10

func _physics_process(delta: float) -> void:
	if $"../".game_paused:
		return
	handle_hit()
	if state == "idle":
		handle_facing()

	# get new state
	var prev_state = state
	handle_input()
	if missed:
		goto_idle()

	# play new anim
	var new_anim = state + "_" + facing
	if new_anim != anim or prev_state != state:
		anim = new_anim
		$Anims.play(anim)

func handle_input():
	if Input.is_action_just_pressed("attack"):
		state = "attack"
	if Input.is_action_just_pressed("attack_up"):
		state = "attack"
		facing = "up"
	if Input.is_action_just_pressed("attack_down"):
		state = "attack"
		facing = "down"
	if Input.is_action_just_pressed("attack_left"):
		state = "attack"
		facing = "left"
	if Input.is_action_just_pressed("attack_right"):
		state = "attack"
		facing = "right"


var prev_posi : Vector2
func handle_facing():
	var current_posi = ((position + Vector2(get_viewport().size) / 2) - get_viewport().get_mouse_position()).normalized()
	if current_posi == prev_posi:
		return
	prev_posi = current_posi
	
	var angle = current_posi.angle()

	if angle < PI / 4 and angle > -PI / 4:
		facing = "left"
	elif angle > PI / 4 and angle < 3 * PI / 4:
		facing = "up"
	elif angle > -3 * PI / 4 and angle < -PI / 4:
		facing = "down"
	else:
		facing = "right"
	
func goto_idle():
	state = "idle"

var missDetectLoad = preload("res://scenes/misc/MissDetect.tscn")

func attack():
	var collision : Area2D
	if missed:
		return
	if facing == "up":
		collision = $AttackAreaUp
	if facing == "down":
		collision = $AttackAreaDown
	if facing == "left":
		collision = $AttackAreaLeft
	if facing == "right":
		collision = $AttackAreaRight
	collision.find_child("Anims").play("explode")
	for overlapped_body in collision.get_overlapping_bodies():
		if overlapped_body.name.begins_with("Enemy") \
			and not overlapped_body.is_dead \
			and not missed:
				var enemy_animation_manager = overlapped_body.find_children("Anims")[0]
				enemy_animation_manager.play("die")
				striked = true
	if not striked:
		$Timer.start()
		missed = true
		var missDetect = missDetectLoad.instantiate()
		add_child(missDetect)
		missDetect.find_child("Anims").play("Miss")
	else:
		var missDetect = missDetectLoad.instantiate()
		add_child(missDetect)
		missDetect.find_child("Anims").play("Good")
	
	striked = false

func handle_hit():
	handle_hit_in_area($HitAreaDown)
	handle_hit_in_area($HitAreaUp)
	handle_hit_in_area($HitAreaLeft)
	handle_hit_in_area($HitAreaRight)

func handle_hit_in_area(area):
	for el in area.get_overlapping_bodies():
		if el.name.begins_with("Enemy") and not el.is_dead:
			el.find_children("Anims")[0].play("explode")
			striked = true
			health -= 1
			health = max(0, health)


func _on_timer_timeout() -> void:
	missed = false
