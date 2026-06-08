extends CharacterBody2D

# Velocidade do movimento do player
@export var velocidade: float = 300.0

@export var barra_de_vida: TextureProgressBar

# Referência da animação
@onready var anim = $AnimatedSprite2D 

func _physics_process(delta: float) -> void:
	
	# Checamos o movimento lateral (Esquerda/Direita)
	var direcao = Input.get_axis("left", "right")
	
	# Checamos se o botão de ir para a frente da pista está pressionado
	var movendo_frente = Input.is_action_pressed("ui_up")
	
	if movendo_frente:
		# 1. Se a pista está andando, a animação de correr DEVE tocar
		anim.play("correr")
		
		# 2. Permite que ele se mova para os lados enquanto corre
		if direcao:
			velocity.x = direcao * velocidade
			
			# Vira o sprite para o lado que está indo
			if direcao < 0:
				anim.flip_h = true
			elif direcao > 0:
				anim.flip_h = false
		else:
			# Se está indo pra frente mas soltou as setas laterais, ele para de ir pro lado
			velocity.x = move_toward(velocity.x, 0, velocidade)
			
	else:
		# 3. Se soltou o botão de ir para frente, a pista para.
		# O player perde a velocidade lateral e toca a animação de respiro
		velocity.x = move_toward(velocity.x, 0, velocidade)
		anim.play("respiro")

	# Aplica o movimento com física
	move_and_slide()


# --- FUNÇÃO QUE DETECTA OS ITENS DA PISTA (COLISÃO DE VOLTA) ---
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
