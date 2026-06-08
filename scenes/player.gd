extends CharacterBody2D

# Velocidade do movimento do player
@export var velocidade: float = 300.0

# NOVO: Arraste o nó do Player2 para cá no Inspector!
@export var script_vida: Node2D

# Referência da animação
@onready var anim = $AnimatedSprite2D 

func _physics_process(delta: float) -> void:
	var direcao = Input.get_axis("left", "right")
	var movendo_frente = Input.is_action_pressed("ui_up")
	
	if movendo_frente:
		anim.play("correr")
		if direcao:
			velocity.x = direcao * velocidade
			if direcao < 0:
				anim.flip_h = true
			elif direcao > 0:
				anim.flip_h = false
		else:
			velocity.x = move_toward(velocity.x, 0, velocidade)
	else:
		velocity.x = move_toward(velocity.x, 0, velocidade)
		anim.play("respiro")

	move_and_slide()

# --- FUNÇÃO QUE DETECTA OS ITENS DA PISTA ---
func _on_detector_de_itens_area_entered(area: Area2D) -> void:
	if "eh_saudavel" in area:
		if area.eh_saudavel:
			print("Item Saudavel coletado! (Ganha vida)")
			# Se o Player2 estiver conectado, manda ele rodar a função de curar
			if script_vida:
				script_vida.ganhar_vida()
		else:
			print("Obstaculo Nao Saudavel atingido! (Toma Dano)")
			# Se o Player2 estiver conectado, manda ele rodar a função de dano
			if script_vida:
				script_vida.tomar_dano()
		
		area.queue_free()
