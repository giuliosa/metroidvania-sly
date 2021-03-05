extends Actor

export(int) var hp = 1
export(Vector2) var size = Vector2(1,1)

var direction = 1

var in_atack = false
var timeToAtack = .2

func _ready():
	scale = size
	pass
	
func dead():
	hp -= 1
	print(hp)
	
	if hp <= 0:
		is_dead = true
		$Colisao.set_deferred("disabled", true)
		velocity = Vector2(0, 0)
		$AnimPlayer.play("hurt")
		
		$Timer.start()
		
		if scale > Vector2(1,1):
			get_parent().get_node("ScreenShake").screen_shake(1, 10, 100)
	else:
		print('entrou aqui no else')
		velocity = Vector2(0, 0)
		$AnimPlayer.play("hurt")

func _physics_process(_delta):
	if is_dead == false && in_atack == false:
		velocity.x = speed * direction
		
		if direction == 1:
			$Sprite.flip_h = false
		else:
			$Sprite.flip_h = true
			
			
		$AnimPlayer.play("walk")
		velocity.y += gravity
		
		velocity = move_and_slide(velocity, FLOOR)
	
	
	if is_on_wall():
		change_direction()
	
	if $RayCast2D.is_colliding() == false:
		change_direction()

func change_direction():
	direction *= -1
	$RayCast2D.position.x *= -1

func _on_Timer_timeout():
	queue_free()

var player
var atack_sucess = false

func _on_areaAtack_body_entered(body):
	if "Player" in body.name && in_atack == false:
		atack_sucess = true
		in_atack = true
		player = body
		$AnimPlayer.play("atack")
		$areaAtack/damage.start(timeToAtack)
		$areaAtack/finishAtack.start()


func _on_damage_timeout():
	if atack_sucess == true && in_atack == true:
		player.hurt()

func _on_finishAtack_timeout():
	in_atack = false


func _on_areaAtack_body_exited(body):
	if "Player" in body.name:
		atack_sucess = false
