extends KinematicBody2D

var speed = 100
var player = null
var detection_area = null
var is_moving_towards_player = false

func _ready():
	detection_area = $Area2D  # Referenciar o nó da área de detecção
	detection_area.connect("body_entered", self, "_on_detection_area_body_entered")
	detection_area.connect("body_exited", self, "_on_detection_area_body_exited")
	
	# Iniciar animação idle
	$AnimationPlayer.play("idle")

func _physics_process(delta):
	if is_moving_towards_player and player:
		var direction = (player.position - position).normalized()
		move_and_slide(direction * speed)

func _on_detection_area_body_entered(body):
	if body.name == "Player":
		player = body
		is_moving_towards_player = true
		# Aqui você poderia adicionar código para interromper a animação idle
		$Sprite.stop() 

func _on_detection_area_body_exited(body):
	if body == player:
		player = null
		is_moving_towards_player = false
		# Aqui você pode reiniciar a animação idle
		$Sprite.play("idle_animation")

func _on_Hitbox_area_entered(area):
	if area.name == "Player":
		area.call_deferred("die")  # Chama o método "die" do jogador após um pequeno atraso para evitar problemas com a fila de processamento
