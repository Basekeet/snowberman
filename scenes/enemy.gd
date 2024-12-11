extends CharacterBody2D

const SPEED_LEFT = 108
const SPEED_UP = 54
const SPEED_RIGHT = 100
const SPEED_DOWN = 49
@export var direction = ""

func _ready():
	$AnimationPlayer.play("Base/walk_" + direction)
	$Timer.start()
	
func _physics_process(delta: float) -> void:
	if direction == "left":
		velocity.x = -SPEED_LEFT
	elif direction == "right":
		velocity.x = SPEED_RIGHT
	elif direction == "up":
		velocity.y = -SPEED_UP
	elif direction == "down":
		velocity.y = SPEED_DOWN
	move_and_slide()
	
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()
