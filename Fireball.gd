extends Area2D

const SPEED = 100
var velocity = Vector2()
var direction = 1

func _ready():
	pass # Replace with function body.

func set_fireball_direction(dir):
	direction = dir
	if dir == -1:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false
		

func _physics_process(delta):
	velocity.x = SPEED * delta * direction
	translate(velocity)
	$AnimationPlayer.play("fireball")

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Fireball_body_entered(body):
	if "Enemy" in body.name:
		body.dead()
		queue_free()
