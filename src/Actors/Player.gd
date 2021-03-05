extends Actor

const JUMP_POWER = -290

const FIREBALL = preload("res://Fireball.tscn")

var on_ground = false

var is_attacking = false

var life = 5
var attackPoints = 3

func _physics_process(delta):
	
	if is_dead == false:
	
		if Input.is_action_pressed("ui_right"):
			if is_attacking == false or is_on_floor() == false:
				if is_attacking == false :
					$AnimMove.play("Run")
					velocity.x = speed
					$Sprite.flip_h = false
					if sign($Position2D.position.x) == -1:
						$Position2D.position.x *= -1
						$Sprite/swordHit.position.x *= -1
				
					
		elif Input.is_action_pressed("ui_left"):
			if is_attacking == false or is_on_floor() == false:
				if is_attacking == false:
					$AnimMove.play("Run")
					velocity.x = -speed
					$Sprite.flip_h = true
					if sign($Position2D.position.x) == 1:
						$Position2D.position.x *= -1
						$Sprite/swordHit.position.x *= -1
					
		else:
			velocity.x = 0
			if on_ground == true && is_attacking == false: 
				$AnimMove.play("Idle")
				
			
		if Input.is_action_pressed("ui_up") && is_attacking == false:
			if on_ground == true: 
				velocity.y = JUMP_POWER
				on_ground = false
				
		if Input.is_action_just_pressed("ui_shoot") && is_attacking == false:
			if is_on_floor():
				velocity.x = 0
			is_attacking = true
			$AnimMove.play("cast")
			var fireball = FIREBALL.instance()
			fireball.set_fireball_direction(sign($Position2D.position.x))
				
			get_parent().add_child(fireball)
			fireball.position = $Position2D.global_position
		
		if Input.is_action_just_pressed("ui_melee") && is_attacking == false:
			attackWithSword()
			
		if Input.is_action_just_pressed("ui_punch") && is_attacking == false:
			attackWithFist()
		
		velocity.y += gravity
			
		if is_on_floor():
			if on_ground == false:
				is_attacking = false
			on_ground = true
		else: 
			if is_attacking == false:
				on_ground = false
				if velocity.y < 0:
					$AnimMove.play("Jump")
				else:
					$AnimMove.play("fall")
				
			
		velocity = move_and_slide(velocity, FLOOR)
		
		if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if "Enemy" in get_slide_collision(i).collider.name:
					hurt()
	
	
func dead():
	is_dead = true
	velocity = Vector2(0,0)
	$AnimMove.play("hurting") 
	$CollisionShape2D.disabled = true
	$Timer.start()
	
func hurt():
	if(life > 0):		
		life -= 1
		print("Vida igual a")
		print(life)
		$AnimMove.play("hurting") 
	else:
		dead()
		

func attackWithSword():
		
	$attackResetTimer.start()
	if is_on_floor():
		velocity.x = 0
	is_attacking = true
	if attackPoints == 3:
		$AnimMove.play("atacking")
	elif attackPoints == 2: 
		$AnimMove.play("atacking-2")
	elif attackPoints == 1:
		$AnimMove.play("atacking-3")
	attackPoints -= 1
	
func attackWithFist():
	$attackResetTimer.start()
	if is_on_floor():
		velocity.x = 0
	is_attacking = true
	if attackPoints == 3:
		$AnimMove.play("punch")
	elif attackPoints == 2: 
		$AnimMove.play("punch-2")
	elif attackPoints == 1:
		$AnimMove.play("punch-3")
	attackPoints -= 1
	

func _on_AnimMove_animation_finished(anim_name):
	is_attacking = false
	if anim_name == "atacking-3" || anim_name == "punch-3":
		attackPoints = 3

func _on_Timer_timeout():
	get_tree().change_scene("TitleScreen.tscn")

func _on_swordHit_body_entered(body):
	print('entrou um corpo')
	print(body.name)
	if "Enemy" in body.name:
		body.dead()
		

func _on_attackResetTimer_timeout():
	attackPoints = 3

