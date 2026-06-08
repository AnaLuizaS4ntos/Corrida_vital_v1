extends TextureProgressBar

# Essa função será chamada pelo Player toda vez que ele tomar dano ou curar
func atualizar_barra(vida_atual: int, vida_maxima: int) -> void:
	max_value = vida_maxima
	value = vida_atual
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
