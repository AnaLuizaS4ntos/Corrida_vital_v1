extends Node2D

signal cena_final

@export var barra_de_vida: TextureProgressBar

var maxHp = 200.0
var hp = 0.0
var velocidade_do_tempo: float = 200.0 / 60.0 

# --- NOVA VARIÁVEL: LIMITE DE HITS ---
var hits_sofridos: int = 0
@export var limite_de_hits: int = 3 # Bater em 3 comidas não saudáveis = Fim de jogo

func _ready() -> void:
	if barra_de_vida:
		barra_de_vida.max_value = maxHp
		barra_de_vida.value = hp

func _process(delta: float) -> void:
	hp += velocidade_do_tempo * delta 
	hp = clamp(hp, 0.0, maxHp)
	
	if barra_de_vida:
		barra_de_vida.value = hp
	
	if hp >= maxHp:
		print("Vitória! Sobreviveu os 60 segundos!")
		emit_signal("cena_final")
		get_tree().change_scene_to_file("res://scenes/vitoria.tscn")

# --- FUNÇÃO DO HIT (COMIDA NÃO SAUDÁVEL) ---
func tomar_dano():
	hits_sofridos += 1
	print("Tomou um hit da comida ruim! Total de hits: ", hits_sofridos)
	
	# Além de tomar o hit, atrasa o progresso da vitória em um pouco
	hp -= 30.0 
	hp = clamp(hp, 0.0, maxHp)
	
	# Verifica se bateu o limite de hits para dar Game Over
	if hits_sofridos >= limite_de_hits:
		print("Game Over! Comeu muita besteira.")
		get_tree().change_scene_to_file("res://scenes/cena_final.tscn")

# --- FUNÇÃO DO BÔNUS (COMIDA SAUDÁVEL) ---
func ganhar_vida():
	hp += 15.0
	hp = clamp(hp, 0.0, maxHp)
	print("Comeu bem! Ganhou um avanço no tempo.")
