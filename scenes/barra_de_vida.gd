extends TextureProgressBar

@export var vidaProgresso = Node2D

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	max_value = vidaProgresso.maxHp
	value  = vidaProgresso.hp
	
	
	
