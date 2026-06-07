extends Control

func _on_button_start_tutorial_pressed() -> void:
	# Quando o jogador terminar de ler e clicar, vai direto para a corrida!
	get_tree().change_scene_to_file("res://scenes/cena_Rua.tscn")
