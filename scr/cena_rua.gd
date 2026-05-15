extends Node2D


#logica da pista
var color := {
	"grass-dark" :Color(0.22, 0.447, 0.0, 1.0),
	"grass_light" :Color(0.031, 0.184, 0.0, 1.0),
	"border_dark" :Color(1.0, 0.0, 0.0, 1.0),
	"border_ligth" :Color(0.42, 0.42, 0.42),
	"road_dark" :Color(0.4, 0.4, 0.4),
	"strip_dark" :Color(0, 0 , 0, 0),
	"strip_ligth" :Color(1, 1, 1),
}

#variavel da posicao da pista
var width :=1024
var heigth := 600
var road_width := 2000
var seg := 200
var cam := 0.85
var lines := []
var pos := 0
var num
var skyline_pos := 0.0
var skyline_h := 0


#variavel de direcao
var road_length := 2000
var direction := 0

@onready var captura_de_tela: Sprite2D = $CapturaDeTela20260515012241


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(road_length):
		lines.append({x=0, y=0, z=0, X=0, Y=0, W=0, scale = 0, curve = 0})
		lines[i].z = i * seg + 0.00000001
		
	num = lines.size()


#desenhando a pista
func _draw():
	# Loop que desenha os segmentos de trás para frente (horizonte para baixo)
	var start_pos = pos / seg
	
	for i in range(1, 300): # Desenha 300 segmentos à frente
		var curr = lines[(start_pos + i) % num]
		var prev = lines[(start_pos + i - 1) % num]
		
		# Determina se o segmento é claro ou escuro para o efeito de "zebra"
		var is_dark = (start_pos + i) % 6 < 3
		var grass_color = color["grass-dark"] if is_dark else color["grass_light"]
		var road_color = color["road_dark"] if is_dark else color["border_ligth"] # Ajuste as cores conforme preferir
		
		# Desenha a Grama (Fundo)
		draw_rect(Rect2(0, prev.Y, width, curr.Y - prev.Y), grass_color)
		
		# Desenha a Pista (Trapézio)
		var points = PackedVector2Array([
			Vector2(prev.X - prev.W, prev.Y), # A
			Vector2(prev.X + prev.W, prev.Y), # B
			Vector2(curr.X + curr.W, curr.Y), # C
			Vector2(curr.X - curr.W, curr.Y)  # D
		])
		draw_colored_polygon(points, road_color)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
