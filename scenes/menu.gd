extends Node2D 

# Função criada pelo sinal do botão Start
func _on_button_start_pressed() -> void:
	# Função mágica do Godot que troca a cena atual pela cena do jogo
	# Usamos o caminho correto apontando para a sua pasta 'scenes'
	get_tree().change_scene_to_file("res://scenes/cena_Rua.tscn")


func _on_button_tutorial_pressed() -> void:
	# Abre a tela explicativa do médico
	get_tree().change_scene_to_file("res://scenes/tutorial.tscn")
	
	
