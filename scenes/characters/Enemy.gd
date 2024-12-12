extends CharacterBody2D

var speed = 0
var is_dead = false
var direction = "left"

func _ready():
	$Anims.play("walk_" + direction)
	
func prepare_die():
	is_dead = true
	$CollisionBox.disabled = true
	
func die():
	get_parent().remove_child(self)
	
func _physics_process(delta: float) -> void:
	if not is_dead:
		if direction == "left":
			velocity.x = -speed
		elif direction == "right":
			velocity.x = speed
		elif direction == "up":
			velocity.y = -speed
		elif direction == "down":
			velocity.y = speed
		move_and_slide()
