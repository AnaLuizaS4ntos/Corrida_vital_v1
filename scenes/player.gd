extends CharacterBody2D

# Velocidade do movimento do player
@export var velocidade: float = 300.0

func _physics_process(delta: float) -> void:
	
	var direcao = Input.get_axis("left", "right")
	
	if direcao:
		# Se estiver pressionando algo, move o player no eixo X
		velocity.x = direcao * velocidade
	else:
		# Se soltar as teclas, o player para suavemente
		velocity.x = move_toward(velocity.x, 0, velocidade)

	# Aplica o movimento com física e colisão
	move_and_slide()


# --- FUNÇÃO QUE DETECTA OS ITENS DA PISTA ---
func _on_detector_de_itens_area_entered(area: Area2D) -> void:
	# Verificamos se o objeto em que o player encostou possui a variável 'eh_saudavel'
	if "eh_saudavel" in area:
		if area.eh_saudavel:
			# Código quando toca em algo Saudável (Frutas)
			print("Item Saudavel coletado! (Sumindo)")
		else:
			# Código quando toca em algo Não Saudável (Hambúrguer, cigarro, etc.)
			print("Obstaculo Nao Saudavel atingido! (Sumindo)")
		
		# Esta linha deleta o item do jogo imediatamente ao toque
		area.queue_free()
