extends Area2D

var segment_index: int = 0  
var offset_x: float = 0.0   
var eh_saudavel: bool = false

func _ready() -> void:
	# Procura pelo nó "cigarro" ou qualquer AnimatedSprite2D na cena
	var anim_sprite = get_node_or_null("cigarro")
	if anim_sprite == null:
		for child in get_children():
			if child is AnimatedSprite2D:
				anim_sprite = child
				break
				
	if anim_sprite and anim_sprite.sprite_frames:
		var lista_animacoes = anim_sprite.sprite_frames.get_animation_names()
		var animacao_sorteada = lista_animacoes[randi() % lista_animacoes.size()]
		anim_sprite.animation = animacao_sorteada
