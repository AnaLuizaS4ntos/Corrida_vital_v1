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
	
func _draw_road(color: Color, x1: float, y1: float, w1: float, x2: float, y2: float, w2: float) -> void:
	#definindo os 4 pontos do trapézio (A, B, C, D)
	var a = Vector2(x1 - w1, y1)
	var b = Vector2(x2 - w2, y2)
	var c = Vector2(x2 + w2, y2)
	var d = Vector2(x1 + w1, y1)
	
	var points = PackedVector2Array([a, b, c, d])
	
	draw_colored_polygon(points, color)

func _line(line, cam_x, cam_y, cam_z):
	line.scale = cam / (line.z - cam_z)
	line.X= (1+ line.scale * (line.x - cam_x)) * width /2
	line.Y = (1- line.scale * (line.y - cam_y)) * heigth /2
	line.W = line.scale * road_width * (width/2)
	return line
	



func _draw() -> void:
	_draw_road(Color.RED, 512, 400, 200, 512, 200, 50)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
