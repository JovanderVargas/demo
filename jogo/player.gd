extends KinematicBody2D

var Gravity = 20
var Speed = 100
var Motion = Vector2()
var UP = Vector2(0, -1)
var jumpforce = 300
var jump_increase = 50
var is_attacking = false
var attack_direction = 1

func _physics_process(delta):
	Motion.y += Gravity

	if is_on_floor():
		Motion.y = 0  # Reset Y motion if on floor
		jumpforce = 300  # Reset jump force when on the floor

	if not is_attacking:
		if Input.is_action_pressed("left"):
			Motion.x = -Speed
			attack_direction = -1
			$Sprite.flip_h = true
			$AnimationPlayer.play("walk")
		elif Input.is_action_pressed("right"):
			Motion.x = Speed
			attack_direction = 1
			$Sprite.flip_h = false
			$AnimationPlayer.play("walk")
		else:
			Motion.x = 0
			$AnimationPlayer.play("idle")

		if Input.is_action_just_pressed("jump"):
			Motion.y -= jumpforce  # Add jumpforce to the current vertical motion
			jumpforce += jump_increase

	Motion = move_and_slide(Motion, UP)

	if Input.is_action_just_pressed("attack") and not is_attacking:
		attack()

	if is_attacking and Input.is_action_just_released("attack"):
		stop_attack()

func attack():
	is_attacking = true
	$AnimationPlayer.play("run")
	Motion.x = 0  # Impede o movimento durante o ataque

func stop_attack():
	is_attacking = false
	$AnimationPlayer.stop()  # Parar a animação de ataque
	$AnimationPlayer.play("idle")  # Voltar à animação "idle"

func _on_Hitbox_area_entered(area):
	if area.is_in_group("Enemy"):
		area.queue_free()  # Destruir o inimigo quando a hitbox tocar nele
		die()

func die():
	# Adicione aqui a lógica para animação de morte, som de morte, etc.
	queue_free()  # Destruir o jogador
