extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var tilemap : TileMap

var anim = "NONE"
var facing = "left"
var state = "idle"

var health = 3

func _physics_process(delta: float) -> void:
	handle_health()
	handle_hit()
	var prev_state = state
	if state == "idle":
		handle_facing()
	if Input.is_action_just_pressed("attack"):
		state = "attack"
	var new_anim = state + "_" + facing
	if new_anim != anim or prev_state != state:
		anim = new_anim
		$AnimationPlayer.play(anim)

func handle_facing():
	var current_posi
	var v = ((position + Vector2(get_viewport().size) / 2) - get_viewport().get_mouse_position()).normalized()
	var angle = v.angle()
	
	
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
	
func is_takt():
	return randi() % 1 == 0

func attack():
	var collision : Area2D
	if not is_takt():
		return
	if facing == "up":
		collision = $collision_up
	if facing == "down":
		collision = $collision_down
	if facing == "left":
		collision = $collision_left
	if facing == "right":
		collision = $collision_right
	collision.find_child("AnimationPlayer").play("explode")
	for el in collision.get_overlapping_bodies():
		if el.name.begins_with("Enemy"):
			el.get_parent().remove_child(el)
			

func handle_health():
	if health <= 0:
		get_tree().paused = true

func handle_hit():
	handle_hit_in_area($collision_hit_down)
	handle_hit_in_area($collision_hit_up)
	handle_hit_in_area($collision_hit_left)
	handle_hit_in_area($collision_hit_right)

func handle_hit_in_area(area):
	for el in area.get_overlapping_bodies():
		if el.name.begins_with("Enemy"):
			el.get_parent().remove_child(el)
			health -= 1
			health = max(0, health)
			print(health)
			
		
func get_health():
	return health
