extends CharacterBody2D

const SPEED = 100
var is_dead = false
var direction = "left"

func _ready():
	$Anims.play("walk_" + direction)
	
func prepare_die():
	is_dead = true
	
func die():
	get_parent().remove_child(self)
	
func _physics_process(delta: float) -> void:
	if not is_dead:
		if direction == "left":
			velocity.x = -SPEED
		elif direction == "right":
			velocity.x = SPEED
		elif direction == "up":
			velocity.y = -SPEED
		elif direction == "down":
			velocity.y = SPEED
		move_and_slide()
