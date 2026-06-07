extends Area2D

var segment_index: int = 0  
var offset_x: float = 0.0   
var eh_saudavel: bool = true

func _ready() -> void:
	# Procura automaticamente qualquer AnimatedSprite2D dentro da cena
	var anim_sprite = get_node_or_null("frutas")
	if anim_sprite == null:
		# Se não achou com o nome "frutas", pega o primeiro nó de animação disponível
		for child in get_children():
			if child is AnimatedSprite2D:
				anim_sprite = child
				break
				
	if anim_sprite and anim_sprite.sprite_frames:
		var lista_animacoes = anim_sprite.sprite_frames.get_animation_names()
		var animacao_sorteada = lista_animacoes[randi() % lista_animacoes.size()]
		anim_sprite.animation = animacao_sorteada
