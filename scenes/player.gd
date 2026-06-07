extends CharacterBody2D

# Velocidade do movimento do player
@export var velocidade: float = 300.0

func _physics_process(delta: float) -> void:
	# Aqui trocamos para "left" e "right", exatamente como está na imagem image_a64127.png
	var direcao = Input.get_axis("ui_left", "ui_right")
	
	if direcao:
		# Se estiver pressionando algo, move o player no eixo X
		velocity.x = direcao * velocidade
	else:
		# Se soltar as teclas, o player para suavemente
		velocity.x = move_toward(velocity.x, 0, velocidade)

	# Aplica o movimento com física e colisão
	move_and_slide()
